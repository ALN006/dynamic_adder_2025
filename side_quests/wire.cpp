// TODO:    1. make copy constructor match assignment opperator

/*
    INTRO PARAGRAPH:
    This program defines a templated wire class for an event based C++ digital logic simulation library

*/

// defining boolean operations
#include <unordered_map>
#include <stdexcept>

std::unordered_map<char, char> operations[3] = {
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
//              -> char ownership_       : 1 if object owns its value, else 0
//
// member_functions -> wire(char* val, component* start, component* end, int width) : normal constructor (blind trust attribute assignment)
//                  -> void operator = (const wire& driver)                         : shallow copy, its like connecting 2 wires,there is no deep copy in this class as that doesnt make sense for a wire
//                  -> ~wire()                                                      : destructor deallocates value
//                  -> getters                                                      : get_value(), get_start(), get_end(), get_width()
//                  -> setters                                                      : set_value()
//                  -> opperators                                                   : &, ~, | (boolean bitwise, returns values and not wires)
template <class component, class integer>
class wire{
    private:
        char* value_;
        integer width_;
        component* start_;
        component* end_; 
        char ownership_;
    public:
        // blind trust attribute assignment in constructor
        wire(char* val, component* start, component* end, int width): start_(start), end_(end), width_(width), ownership_(1) {
            this->value_ = new char[width];
            for (integer i = 0; i < width; i++){ this->value_[i] = val[i]; }
        }
        //just for safety of return statements
        wire(const wire& w): width_(w.width_), start_(w.start_), end_(w.end_), ownership_(1) {
            this->value_ = new char[this->width_];
            for (integer i = 0; i < this->width_; i++) { this->value_[i] = w.value_[i]; }
        }

        ~wire(){ if(this->ownership_ == 1) { delete[] this->value_; } } //dtor
        
        // getters (shallow when returning pointers)
        const char* get_value() const { return value_; }
        const component* get_start() const { return start_; }
        const component* get_end() const { return end_; }
        integer get_width() const { return width_; }

        //setter 
        void set_value(char* new_value) { for (integer i = 0; i < this->width_; i++){ this->value_[i] = new_value[i]; } }

        // to connect wires, does not change start_ and end_
        // note object should not outlive driver
        wire& operator = (const wire& driver) {
            if (this != &driver) {
                if (this->width_ != driver.width_) { throw std::invalid_argument("Width mismatch in assignment"); }
                if (this->ownership_ != 1) { throw std::logic_error("wire is already connected to a driver"); }
                delete[] this->value_;
                this->value_ = driver.value_; 
                this->ownership_ = 0;
            }
            return *this;
        }

        // bitwise opperators
        wire operator & (const wire& w) const {
            if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in &"); }
            char* tmp = new char[width_];
            for (integer i = 0; i < width_; i++) { tmp[i] = operations[0][(char)(value_[i] + w.value_[i])]; }
            wire res(tmp, NULL, NULL, width_);
            delete[] tmp; // res constructor makes its own copy
            return res;
        }
        wire operator ~ () const {
            char* tmp = new char[width_];
            for (integer i = 0; i < width_; i++) { tmp[i] = operations[1][value_[i]]; }
            wire res(tmp, NULL, NULL, width_);
            delete[] tmp;
            return res;
        }
        wire operator | (const wire& w) const {
            if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in |"); }
            char* tmp = new char[width_];
            for (integer i = 0; i < width_; i++) { tmp[i] = operations[2][(char)(value_[i] + w.value_[i])]; }
            wire res(tmp, NULL, NULL, width_);
            delete[] tmp;
            return res;
        }
};