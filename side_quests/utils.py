import time

def timeit(function_under_test: object, *args, **kwargs) -> object: #performance timer
    '''
    prints the runtime of function under test
    returns result, time_elapsed
    '''
    start = time.perf_counter()
    result = function_under_test(*args,**kwargs)
    time_elapsed = time.perf_counter() - start
    print(f"Elapsed time: {time_elapsed:.6f} seconds")
    return result, time_elapsed