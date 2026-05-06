// this program defines a component class for an event based digital logic 
// TODO:    implement constructor
// include chain: component_space <- wire_space <- logic <- stdexcept

#include "wire.cpp"

namespace component_space {

    using namespace wire_space;

    // Base and Leaf Class Component
    // a component is an object with an input_[] wire array,  an output_[] wire array and a logic function that describes the relation between input_[] and output_[] 
    class component{
        private:
            void (*logic_)();
            int n_inputs_;
            int n_outputs_;
            wire<component, long>* inputs_;
            wire<component, long>* outputs_;
        public:
        
    };
}