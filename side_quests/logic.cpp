// defined here is the core logic representation used by our event based digital hardware simulator in C++
// TODO:    1. choose a hardware standard to refrance from and mention it here
//          2. define xor, nand, nor, xnor

// include chain: logic <- stdexcept

#include <stdexcept>

namespace logic {
    // logic represntation 
    enum logic_value : uint8_t { L0 = 0, L1 = 1, LX = 2, LZ = 3 };

    // defining boolean operations
    //                                L0        L1        LX        LZ
    constexpr logic_value and_table[4][4] = {
        /* L0 */            { L0,   L0,   L0,   L0 },
        /* L1 */            { L0,   L1,   LX,   LX },
        /* LX */            { L0,   LX,   LX,   LX },
        /* LZ */            { L0,   LX,   LX,   LX },
    };
    constexpr logic_value or_table[4][4] = {
        /* L0 */            { L0,   L1,   LX,   LX },
        /* L1 */            { L1,   L1,   L1,   L1 },
        /* LX */            { LX,   L1,   LX,   LX },
        /* LZ */            { LX,   L1,   LX,   LX },
    };
    constexpr logic_value not_table[4] = { L1, L0, LX, LZ };

    // functions for top level I/O
    logic_value char_to_lv(char c) {
        switch(c) {
            case '0': return L0;
            case '1': return L1;
            case 'X': return LX;
            case 'Z': return LZ;
            default : throw std::invalid_argument("invalid logic character");
        }
    }
    char lv_to_char(logic_value c) {
        switch(c) {
            case L0 : return '0';
            case L1 : return '1';
            case LX : return 'X';
            case LZ : return 'Z';
            default : throw std::invalid_argument("invalid logic value");
        }
    }
}