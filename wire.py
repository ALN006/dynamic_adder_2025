import numpy as np
class wire(object):

    values = [0,1,"X", "Z"]

    def __init__(self, signal: np.array) -> wire:
        self.signal = signal
    
    @classmethod # alternative contructor that takes human readable signal r_signal
    def from_signal(cls, r_signal):
        signal = np.array([])
        for bit in r_signal:
            for index,value in enumerate(wire.values):
                if bit == value:
                    np.append(signal,index)
        return cls(signal)

    def read(self) -> np.array: return self.signal
    
    def __getitem__(self, index: int) -> int: return self.signal[index]
    
    def __getslice__(self, i: int = 0, j: int = -1) -> np.array: return self.signal[i:j]
    
    def __str__(self) -> str: return str([wire.values[pointer] for pointer in self.signal])
    
    def __repr__(self) -> str: return f"wire.__init__(self,{self.signal})"
    
    def write(self, signal: np.array) -> None: self.signal = signal

    def assign(self, r_signal: np.array) -> None:
        self.signal = np.array([])
        for bit in r_signal:
            for index,value in enumerate(wire.values):
                if bit == value:
                    np.append(self.signal,index)

    def is_01(self,index: int) -> bool:
        return wire.values[self.signal[index]] in [0,1]
    
    def __mul__(self,other): #the and operation (doesnt handles only 0, 1 states for now)
        return (self.signal)*(other.signal)
    
    