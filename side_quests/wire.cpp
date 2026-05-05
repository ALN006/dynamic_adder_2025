// This program defines a templated wire class for an event based C++ digital logic simulation librarybit
// TODO:    1. consider implementing a slice operator
//          2. switch to 0, 1, 2, 3 encoding internally instead of '0', '1', 'X', 'Z' to enable replacement of operation maps bellow with normal arrays

#include <unordered_map>
#include <stdexcept>

// defining boolean operations
const std::unordered_map<char, char> operations[3] = {
    //and
    {
        {(char)('0' + '0'), '0'},{(char)('0' + '1'), '0'},{(char)('1' + '1'), '1'}, 
        {(char)('X' + 'X'), 'X'},{(char)('0' + 'X'), '0'},{(char)('1' + 'X'), 'X'},
        {(char)('X' + 'Z'), 'X'},{(char)('Z' + 'Z'), 'Z'},{(char)('Z' + '0'), '0'},
        {(char)('Z' + '1'), 'X'} 
    },
    //not
    {
        {'0', '1'},{'1', '0'},
        {'X', 'X'},{'Z', 'Z'}
    },
    //or
    {
        {(char)('0' + '0'), '0'},{(char)('0' + '1'), '1'},{(char)('1' + '1'), '1'},
        {(char)('X' + 'X'), 'X'},{(char)('0' + 'X'), 'X'},{(char)('1' + 'X'), '1'},
        {(char)('X' + 'Z'), 'X'},{(char)('Z' + 'Z'), 'Z'}, {(char)('Z' + '0'), '0'},
        {(char)('Z' + '1'), '1'}
    }
};

// Base and Leaf class wire 
// a wire is a group of chanels that connect one start_ component to one end_ component
// the chanels here are stored as a C style character array with the following encoding
//      '1' -> logical high 
//      '0' -> logical low
//      'X' -> Dont Care / Unknown
//      'Z' -> High impedance 
//
// attributes   -> char* value_         : logical value of the wire e.g. xECEB
//              -> integer width_       : number of bits
//              -> component* start_    : not owned by object itself
//              -> component* end_      : not owned by object itself
//              -> char owns_value_       : 1 if object owns its value, else 0
//
// member_functions -> wire(char* val, component* start, component* end, int width) : normal constructor (blind trust attribute assignment)
//                  -> other ctors                                                  : deep copy, default, move ctor (shallow for return statements)
//                  -> wire& operator = (const wire& driver)                        : deep copy
//                  -> void assign_driver(const wire& driver)                       : shallow copy
//                  -> ~wire()                                                      : destructor deallocates value
//                  -> getters                                                      : get_value(), get_start(), get_end(), get_width()
//                  -> setters                                                      : set_value()
//                  -> opperators                                                   : &, ~, | (boolean bitwise, returns values and not wires) (throws out of range error for invalid inputs)
template <class component, class integer>
class wire{
    private:
        char* value_;
        integer width_;
        component* start_;
        component* end_; 
        bool owns_value_; // 1 if owning, 0 if alias/connected
    public:
        // default constructor 
        wire():start_(NULL), end_(NULL), width_(0), value_(NULL), owns_value_(0) {}

        // blind trust attribute assignment in constructor
        wire(const char* val, component* start, component* end, integer width): start_(start), end_(end), width_(width), owns_value_(1) {
            this->value_ = new char[width];
            for (integer i = 0; i < width; i++){ this->value_[i] = val[i]; }
        }
        //copy constructor for container safety
        wire(const wire& w): width_(w.width_), start_(w.start_), end_(w.end_), owns_value_(1) {
            this->value_ = new char[this->width_];
            for (integer i = 0; i < this->width_; i++) { this->value_[i] = w.value_[i]; }
        }

        wire(wire&& w) noexcept 
            : value_(w.value_), width_(w.width_),
            start_(w.start_), end_(w.end_), owns_value_(w.owns_value_) {
            w.owns_value_ = 0;    // destructor won't delete
            w.value_ = nullptr;  // defensive — protects against future code changes
        }

        ~wire(){ if(this->owns_value_ == 1) { delete[] this->value_; } } 
        
        // getters (shallow when returning pointers)
        const char* get_value() const { return value_; }
        const component* get_start() const { return start_; }
        const component* get_end() const { return end_; }
        integer get_width() const { return width_; }

        //setter 
        void set_value(const char* new_value) { 
            if (this->owns_value_ == 0) { throw std::logic_error("wire is connected to a designated driver"); }
            for (integer i = 0; i < this->width_; i++){ this->value_[i] = new_value[i]; } 
        }

        // same as copy constructor
        wire& operator = (const wire& w) {
            if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in assignment"); }
            if (this->owns_value_ == 0) { throw std::logic_error("wire is connected to a designated driver"); }
            for (integer i = 0; i < this->width_; i++) { this->value_[i] = w.value_[i]; }
            return *this;
        }

        // connect 2 wires
        // note object should not outlive driver
        void assign_driver(const wire& driver){
            if (this != &driver) {
                if (this->width_ != driver.width_) { throw std::invalid_argument("Width mismatch in assignment"); }
                if (this->owns_value_ == 0) { throw std::logic_error("wire is already connected to a designated driver"); }
                delete[] this->value_;
                this->value_ = driver.value_;
                this->owns_value_ = 0;
            }
        }

        // bitwise opperators, throws out of range error for invalid inputs 
        wire operator & (const wire& w) const {
            if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in &"); }
            wire res;
            res.width_ = this->width_; res.owns_value_ = 1;
            res.value_ = new char[this->width_];
            for (integer i = 0; i < width_; i++) { res.value_[i] = operations[0].at((char)(value_[i] + w.value_[i])); }
            return res;  
        }
        wire operator ~ () const {
            wire res;
            res.width_ = this->width_; res.owns_value_ = 1;
            res.value_ = new char[this->width_];
            for (integer i = 0; i < width_; i++) { res.value_[i] = operations[1].at(value_[i]); }
            return res;  
        }
        wire operator | (const wire& w) const {
            if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in |"); }
            wire res;
            res.width_ = this->width_; res.owns_value_ = 1;
            res.value_ = new char[this->width_];
            for (integer i = 0; i < width_; i++) { res.value_[i] = operations[2].at((char)(value_[i] + w.value_[i])); }
            return res;  
        }
};