class wire(object):
    ''' 
    a wire is a set of chanels that can each posses a voltage so as to carry fixed size indexed signals (order matters)
    the encoding at indexes is as follows:
        0 -> ground/minumum voltage
        1 -> maximum voltage 
        X -> dont care if it is 0 or 1 but it is one of the 2
        Z -> high impedance i.e. a voltage value between max and min that is not capable of activating CMOS transistors

    this class models wires for the purposes of larger ciruit simulations 
    '''

    def __init__(self, signal: list) -> wire: #constructor
        ''' creates wire object self with some initial signal '''
        self.signal  = signal

    def read(self) -> list: #getter
        ''' returns the signal held in our wire'''
        return self.signal
    def __getitem__(self,index: int) -> int: #syntactic sugar
        ''' allows the statement wire2 = wire1[index] '''
        return wire([self.signal[index]])
    def __getslice__(self,i: int = 0, j: int = -1) -> list: #syntactic sugar
        ''' allows the statement wire2 = wire1[i:j] '''
        return wire(self.signal[i:j])
    def __setitem__(self, index: int, value: str) -> None: #setter
        ''' allows the statement wire1[index] = value'''
        self.signal[index] = value
    def __setslice__(self, i: int = 0, j: int = -1, values: list = []) -> None: #setter
        self.signal[i:j] = values
    def __str__(self) -> str: #for display
        ''' returns signal carried as a string '''
        return "".join(self.signal)
    def __repr__(self) -> str: #for debugging
        ''' returns the python statement that created self '''
        return f"wire({self.signal})"
    def __len__(self): #len()
        ''' retruns length of the signal carried by wire '''
        return len(self.signal)

    def is_01(self,index: int) -> bool: #checker
        ''' returns true if the values at index is 0 or 1 '''
        return self.signal[index] in ["0","1"]

    def __and__(self,other: wire) -> wire: #AND gate
        ''' allows A&B to mean A and B bitwise '''
        AND = { #there are just too many edge cases with too few inputs for this and other gates to not be straight dicts
            "00": "0", "01": "0", "0X": "0", "0Z": "0",
            "10": "0", "11": "1", "1X": "X", "1Z": "Z",
            "X0": "0", "X1": "X", "XX": "X", "XZ": "Z", #a safe choice for XZ
            "Z0": "0", "Z1": "Z", "ZX": "Z", "ZZ": "Z"
        }
        return wire([AND[self.signal[i] + other.signal[i]] for i in range(len(self))])
    def __or__(self,other: wire) -> wire: #OR gate
        ''' allows A|B to mean A or B bitwise '''
        OR = { 
            "00": "0", "01": "1", "0X": "X", "0Z": "Z",
            "10": "1", "11": "1", "1X": "1", "1Z": "1",
            "X0": "X", "X1": "1", "XX": "X", "XZ": "Z", #a safe choice for XZ
            "Z0": "Z", "Z1": "1", "ZX": "Z", "ZZ": "Z"
        }
        return wire([OR[self.signal[i] + other.signal[i]] for i in range(len(self))])
    def __xor__(self,other: wire) -> wire: #XOR gate
        ''' allows A^B to mean A xor B bitwise '''
        XOR = { 
            "00": "0", "01": "1", "0X": "X", "0Z": "Z",
            "10": "1", "11": "0", "1X": "X", "1Z": "Z",
            "X0": "X", "X1": "X", "XX": "0", "XZ": "Z", 
            "Z0": "Z", "Z1": "Z", "ZX": "Z", "ZZ": "Z"
        }
        return wire([XOR[self.signal[i] + other.signal[i]] for i in range(len(self))])
    def __invert__(self) -> wire: #NOT gate
        ''' allows ~A to mean not A bitwise '''
        AND = { 
            "0": "1", "1": "0",
            "X": "X", "Z": "Z"
        }
        return wire([AND[self.signal[i]] for i in range(len(self))])
    
    #future work -> all other gates, support gate delays
    # i think dealing with timing should be left for a higher level of abstraction
    # can you do an array of straight bits instead of an array of chars in python ?
