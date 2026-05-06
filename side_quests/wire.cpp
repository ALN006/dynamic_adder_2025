// This program defines a templated wire class for an event based C++ digital logic simulation library
// TODO:    1. consider implementing a slice operator
//          2. consider supporting arithematic operations 

// include chain: wire_space <- logic <- stdexcept

#include "logic.cpp"

namespace wire_space {

    using namespace logic;

    // Base and Leaf class wire 
    // a wire is a group of channels that connect one start_ component to one end_ component
    // the channels here are stored as a logic_value array (see logic.cpp for details)
    //
    // attributes   -> logic_value* value_  : logical value of the wire e.g. xECEB
    //              -> integer width_       : number of bits
    //              -> component* start_    : not owned by object itself
    //              -> component* end_      : not owned by object itself
    //              -> bool owns_value_     : 1 if object owns its value, else 0
    //
    // member_functions -> ctors                                    : default; full (char[] or logic_value[]); logic_value[]; another wire; temporary wire; C string
    //                  -> wire& operator = (... wire)              : deep copy for normal driver, shallow copy for temp driver
    //                  -> void assign_driver(const wire& driver)   : shallow copy
    //                  -> ~wire()                                  : destructor deallocates value
    //                  -> getters                                  : get_value(), get_start(), get_end(), get_width()
    //                  -> opperators                               : &, ~, | (boolean bitwise, returns values and not wires) (throws out of range error for invalid inputs)
    template <class component, class integer>
    class wire{
        private:
            logic_value* value_;
            integer width_;
            component* start_;
            component* end_; 
            bool owns_value_; // 1 if owning, 0 if alias/connected
        public:
            // ctors (blind trust for speed), garbage is read silently if width doesnt match len(val[]), turn on address sanitization for safety
            wire():start_(nullptr), end_(nullptr), width_(0), value_(nullptr), owns_value_(0) {} //default
            wire(const char* val, component* start, component* end, integer width): start_(start), end_(end), width_(width), owns_value_(1) { //from char*, width and start, stop
                this->value_ = new logic_value[width];
                for (integer i = 0; i < width; i++){ this->value_[i] = char_to_lv(val[i]); }
            }
            wire(const logic_value* val, component* start, component* end, integer width): start_(start), end_(end), width_(width), owns_value_(1) { //from logic_value*, wdith and start, stop
                this->value_ = new logic_value[width];
                for (integer i = 0; i < width; i++){ this->value_[i] = val[i]; }
            }
            wire(const logic_value* val, integer width): start_(nullptr), end_(nullptr), width_(width), owns_value_(1){ //from logic_value* and width
                this->value_ = new logic_value[width];
                for (integer i = 0; i < width; i++){ this->value_[i] = val[i]; }
            }
            wire(const wire& w): width_(w.width_), start_(w.start_), end_(w.end_), owns_value_(1) { //from another non-temporary wire
                this->value_ = new logic_value[this->width_];
                for (integer i = 0; i < this->width_; i++) { this->value_[i] = w.value_[i]; }
            }
            wire(wire&& w) noexcept : value_(w.value_), width_(w.width_), start_(w.start_), end_(w.end_), owns_value_(w.owns_value_) { // from temporary wire
                w.owns_value_ = 0;   
                w.value_ = nullptr;  // defensive — protects against future code changes
            }
            wire(const char* val): start_(nullptr), end_(nullptr), owns_value_(1){ //C string
                integer width = 0;
                while (*val != '\0'){ width += 1; val += 1; } 
                val -= width; this->width_ = width;
                this->value_ = new logic_value[this->width_];
                for (integer i = 0; i < width; i++){ this->value_[i] = char_to_lv(val[i]); }
            }

            ~wire(){ if(this->owns_value_ == 1) { delete[] this->value_; } } 
            
            // getters (shallow when returning pointers)
            const logic_value* get_value() const { return value_; }
            const component* get_start() const { return start_; }
            const component* get_end() const { return end_; }
            integer get_width() const { return width_; }


            // assignment opperator
            wire& operator = (const wire& w) {
                if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in assignment"); }
                if (this->owns_value_ == 0) { throw std::logic_error("wire is connected to a designated driver"); }
                for (integer i = 0; i < this->width_; i++) { this->value_[i] = w.value_[i]; }
                return *this;
            }
            wire& operator = (wire&& w) {
                if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in assignment"); }
                if (this->owns_value_ == 0) { throw std::logic_error("wire is connected to a designated driver"); }
                if (this != &w) {
                    delete[] this->value_;  // free old buffer
                    this->value_ = w.value_;
                    this->owns_value_ = w.owns_value_;
                    w.value_ = nullptr; w.owns_value_ = 0; 
                }
                return *this;
            }
            wire& operator = (const char* val) {
                integer width = 0;
                while (*val != '\0'){ width += 1; val += 1; } 
                val -= width;
                if (this->width_ != width) { throw std::invalid_argument("Width mismatch in assignment"); }
                if (this->owns_value_ == 0) { throw std::logic_error("wire is connected to a designated driver"); }
                for (integer i = 0; i < width; i++){ this->value_[i] = char_to_lv(val[i]); }
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
                res.value_ = new logic_value[this->width_];
                for (integer i = 0; i < width_; i++) { res.value_[i] = and_table[value_[i]][w.value_[i]]; }
                return res;  
            }
            wire operator ~ () const {
                wire res;
                res.width_ = this->width_; res.owns_value_ = 1;
                res.value_ = new logic_value[this->width_];
                for (integer i = 0; i < width_; i++) { res.value_[i] = not_table[value_[i]]; }
                return res;  
            }
            wire operator | (const wire& w) const {
                if (this->width_ != w.width_) { throw std::invalid_argument("Width mismatch in |"); }
                wire res;
                res.width_ = this->width_; res.owns_value_ = 1;
                res.value_ = new logic_value[this->width_];
                for (integer i = 0; i < width_; i++) { res.value_[i] = or_table[value_[i]][w.value_[i]]; }
                return res;  
            }
    };
}