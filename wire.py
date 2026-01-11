import numpy as np # a numpy arrat is just an arry that supports partwise math, so a + b = another array c of the same length where c[i] = a[i] + b[i]
class wire(object):

    values = [0,1,"X", "Z"] #all wire will be arrays that point to a value in values, i suppose this can be all chars if we wanted

    def __init__(self, signal: np.array) -> wire: #constructor
        self.signal = signal #signal is a list of pointers (indexs in wire.values)
    
    @classmethod # alternative contructor that takes human readable signal r_signal
    def from_r_signal(cls, r_signal):
        signal = np.array([])
        for bit in r_signal:
            for index,value in enumerate(wire.values):
                if bit == value:
                    signal = np.append(signal,index)
        return cls(signal)

    def read(self) -> np.array: return self.signal #internal read for developer use
    
    def __getitem__(self, index: int) -> int: return self.signal[index] #allows index access
    
    def __getslice__(self, i: int = 0, j: int = -1) -> np.array: return self.signal[i:j] #allows index slic access 
    
    def __str__(self) -> str: return str([wire.values[pointer] for pointer in self.signal]) # for printing
    
    def __repr__(self) -> str: return f"wire.__init__(self,{self.signal})" #for debugging, returns the constructor the created the object with bugs
    
    def write(self, signal: np.array) -> None: self.signal = signal #internal wirte for developer use

    def assign(self, r_signal: np.array) -> None: #for application users to input initial signal values
        self.signal = np.array([])
        for bit in r_signal:
            for index,value in enumerate(wire.values):
                if bit == value:
                    self.signal = np.append(self.signal,index) # this is probably inefficient but i cant put my finger on why

    def is_01(self,index: int) -> bool: # just usefull
        return wire.values[self.signal[index]] in [0,1]
    
    def __mul__(self,other): #the AND operation, supported perfectly, this is why i didnt want to directly use chars directly
        return (self.signal)*(other.signal)
    
    #future work -> all other gates, support gate delays
    