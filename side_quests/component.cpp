#include "wire.cpp"
class component{
    private:
        int delay_;
        double area_;
        void (*logic_)();
        int inputs_;
        int outputs_;
        wire<component, long> inputs;
        wire<component, long> outputs;
    public:
    
};