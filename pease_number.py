"""
Pease Number Calculator
"""


# =============================================================================
# LOOKUP TABLES FOR MEMOIZATION
# =============================================================================

fibo_lookup_table = {}
collatz_lookup_table = {}


# =============================================================================
# FIBONACCI FUNCTION
# =============================================================================

def fibo(n):
    if n in fibo_lookup_table:
        return fibo_lookup_table[n]
    
    if n <= 1:
        result = n
    else:
        result = fibo(n - 1) + fibo(n - 2)
    
    fibo_lookup_table[n] = result
    return result


# =============================================================================
# COLLATZ FUNCTION
# =============================================================================

def collatz_steps(n):
    if n in collatz_lookup_table:
        return collatz_lookup_table[n]
    
    if n == 1:
        result = 0
    elif n % 2 == 0:
        result = 1 + collatz_steps(n // 2)
    else:
        result = 1 + collatz_steps(3 * n + 1)
    
    collatz_lookup_table[n] = result
    return result


# =============================================================================
# PEASE NUMBER CALCULATION
# =============================================================================

def fibonacci_birthday_constant(month, day):
    return (fibo(month), fibo(day))


def collatz_fibo_birthday(fbc, year):
    fibo_month, fibo_day = fbc
    return (
        collatz_steps(fibo_month),
        collatz_steps(fibo_day),
        collatz_steps(year)
    )


def calculate_pease_number(month, day, year):
    fbc = fibonacci_birthday_constant(month, day)
    cfb = collatz_fibo_birthday(fbc, year)
    return sum(cfb)


def display_calculation(month, day, year):
    fbc = fibonacci_birthday_constant(month, day)
    cfb = collatz_fibo_birthday(fbc, year)
    pease = sum(cfb)
    
    print(f"\n{'='*50}")
    print(f"Birthday: [{month}, {day}, {year}]")
    print(f"{'='*50}")
    print(f"\nStep 1 - Fibonacci Birthday Constant:")
    print(f"  Fibo({month}) = {fbc[0]}")
    print(f"  Fibo({day}) = {fbc[1]}")
    print(f"  FBC = [{fbc[0]}, {fbc[1]}]")
    
    print(f"\nStep 2 - Collatz Fibo-Birthday:")
    print(f"  Collatz({fbc[0]}) = {cfb[0]} steps")
    print(f"  Collatz({fbc[1]}) = {cfb[1]} steps")
    print(f"  Collatz({year}) = {cfb[2]} steps")
    print(f"  CFB = [{cfb[0]}, {cfb[1]}, {cfb[2]}]")
    
    print(f"\nStep 3 - Pease Number:")
    print(f"  {cfb[0]} + {cfb[1]} + {cfb[2]} = {pease}")
    print(f"\n>>> Your Pease Number is: {pease} <<<")
    
    # Show extra credit features
    print(f"\n--- Extra Credit Demo ---")
    print(f"Monadic calculation: {calculate_pease_monadic(month, day, year)}")
    print(f"Collatz({year}) converges: {collatz_converges(year)}")
    print(f"{'='*50}\n")
    
    return pease


# =============================================================================
# MAIN PROGRAM
# =============================================================================

def get_user_input():
    print("\nEnter your birthday (or 'q' to quit):")
    
    month_input = input("  Month (1-12): ").strip()
    if month_input.lower() == 'q':
        return None
    
    day_input = input("  Day (1-31): ").strip()
    if day_input.lower() == 'q':
        return None
    
    year_input = input("  Year: ").strip()
    if year_input.lower() == 'q':
        return None
    
    try:
        month = int(month_input)
        day = int(day_input)
        year = int(year_input)
        
        if not (1 <= month <= 12):
            print("Error: Month must be between 1 and 12")
            return "retry"
        if not (1 <= day <= 31):
            print("Error: Day must be between 1 and 31")
            return "retry"
        if year <= 0:
            print("Error: Year must be positive")
            return "retry"
            
        return (month, day, year)
        
    except ValueError:
        print("Error: Please enter valid numbers")
        return "retry"


def main_loop():
    user_input = get_user_input()
    
    if user_input is None:
        print("\nGoodbye!")
        return
    
    if user_input == "retry":
        return main_loop()
    
    month, day, year = user_input
    display_calculation(month, day, year)
    
    return main_loop()


def main():
    print("\n" + "="*50)
    print("   PEASE NUMBER CALCULATOR")
    print("   With Extra Credit Features")
    print("="*50)
    
    main_loop()


# =============================================================================
# EXTRA CREDIT #1: MONADIC CHAINING
# =============================================================================

class PeaseMonad:
    def __init__(self, month=None, day=None, year=None):
        self.month = month
        self.day = day
        self.year = year
        self.fbc = None
        self.cfb = None
        self.pease = None
    
    def bind(self, func):
        func(self)
        return self
    
    def get_value(self):
        return self.pease


def fibo_step(monad):
    monad.fbc = (fibo(monad.month), fibo(monad.day))


def collatz_step(monad):
    monad.cfb = (
        collatz_steps(monad.fbc[0]),
        collatz_steps(monad.fbc[1]),
        collatz_steps(monad.year)
    )


def pease_step(monad):
    monad.pease = sum(monad.cfb)


def calculate_pease_monadic(month, day, year):
    return (PeaseMonad(month, day, year)
            .bind(fibo_step)
            .bind(collatz_step)
            .bind(pease_step)
            .get_value())


# =============================================================================
# EXTRA CREDIT #2: CONVERGENCE DETECTION
# =============================================================================

def collatz_converges(n, seen=None, max_steps=10000):
    if seen is None:
        seen = set()
    
    if n == 1:
        return True
    
    if n in seen:
        return False
    
    if len(seen) >= max_steps:
        return False
    
    new_seen = seen | {n}
    
    if n % 2 == 0:
        return collatz_converges(n // 2, new_seen, max_steps)
    else:
        return collatz_converges(3 * n + 1, new_seen, max_steps)


# =============================================================================
# EXTRA CREDIT #3: CLOSURE PATTERN
# =============================================================================

def make_fibo_with_closure():
    lookup_table = {}
    
    def fibo_closure(n):
        if n in lookup_table:
            return lookup_table[n]
        
        if n <= 1:
            result = n
        else:
            result = fibo_closure(n - 1) + fibo_closure(n - 2)
        
        lookup_table[n] = result
        return result
    
    return fibo_closure


def make_collatz_with_closure():
    lookup_table = {}
    
    def collatz_closure(n):
        if n in lookup_table:
            return lookup_table[n]
        
        if n == 1:
            result = 0
        elif n % 2 == 0:
            result = 1 + collatz_closure(n // 2)
        else:
            result = 1 + collatz_closure(3 * n + 1)
        
        lookup_table[n] = result
        return result
    
    return collatz_closure




if __name__ == "__main__":
    main()
