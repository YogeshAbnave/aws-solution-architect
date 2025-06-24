
---

## ✅ 1. Data Structures and Algorithms

### 📌 Arrays / Lists

1. Reverse a list without using built-in reverse methods.
2. How would you find the second smallest unique number in a list?
3. Check if a given list of integers is a palindrome.
4. Write a function to remove duplicate elements from a list while preserving order.
5. Implement bubble sort without using the `sort()` or `sorted()` functions.
6. Given a list of numbers, return the top 3 most frequent elements.
7. Find the longest increasing sub-sequence in an unsorted list of integers.
8. Rotate a list to the right by `k` steps.

### 📌 Strings

9. Write a function to check if a given string is a palindrome, ignoring case and spaces.
10. Count the number of vowels and consonants in a given string.
11. Find the longest substring without repeating characters.
12. Check if two strings are one edit away (insert, delete, or replace a character).
13. Implement a function that reverses the words in a sentence without reversing the characters.
14. Find the most frequent character in a string, excluding whitespace.

### 📌 Dictionaries

15. Write a function that returns the key with the highest value from a dictionary.
16. Merge two dictionaries such that common keys have their values added together.
17. Count the frequency of each character in a given string using a dictionary.
18. Group words that are anagrams of each other using a dictionary.

### 📌 Linked Lists

19. Implement a function to find the middle element of a singly linked list.
20. Detect if a linked list has a cycle (loop) in it.
21. Reverse a singly linked list using iteration.
22. Merge two sorted linked lists into a single sorted linked list.

### 📌 Recursion

23. Write a recursive function to compute the factorial of a number.
24. Generate the nth Fibonacci number using recursion with memoization.
25. Count the number of paths from the top-left to the bottom-right in a grid using recursion.

### 📌 Searching / Traversing

26. Implement a linear search function and return the index of the element.
27. Implement binary search on a sorted list without using built-in search methods.
28. Count the number of occurrences of an element using binary search.
29. Implement DFS (Depth-First Search) on a graph using adjacency list representation.
30. Implement BFS (Breadth-First Search) and return the shortest path from source to destination in an unweighted graph.

---

## ✅ 2. Python Fundamentals

### 📌 Language Features

31. Create a list of squares of all even numbers between 1 and 20 using list comprehension.
32. Explain the use of `*args` and `**kwargs` in a Python function and implement a logging wrapper function.
33. Implement a simple decorator that logs the execution time of a function.
34. Create a generator function that yields even numbers indefinitely.
35. Explain and demonstrate the difference between an iterator and a generator in Python.
36. Write a lambda function to sort a list of dictionaries by a nested key.
37. Serialize a Python object using pickle and demonstrate how to read it back.
38. Explain how Python's garbage collection handles cyclic references.
39. Write code to demonstrate the impact of the Global Interpreter Lock (GIL) using multithreading.
40. Show the difference between shallow and deep copy with mutable objects.

---

## ✅ 3. Problem Solving

### 📌 Algorithmic Thinking

41. Write a function to check if two strings are anagrams.
42. Determine if a given number is an Armstrong number.
43. Check whether a year is a leap year without using built-in libraries.
44. Merge two already sorted lists into one sorted list without using extra space.
45. Count the number of words in a paragraph-like sentence.
46. Write a function to calculate the digital root of a number.
47. Create a program to simulate a basic calculator using functions and input parsing.
48. Given a list of meeting times, determine if a person can attend all meetings without overlap.

---

## ✅ 4. Object-Oriented Programming (OOP)

### 📌 Concepts and Implementation

49. Define a `BankAccount` class with methods for deposit, withdrawal, and balance inquiry.
50. Implement a base class `Employee` and derive a class `Manager` that includes a list of employees managed.
51. Demonstrate polymorphism using a method called `speak()` in two classes: `Dog` and `Cat`.
52. Write an example of encapsulation by creating a class with private variables and public getters/setters.
53. Implement a class method and a static method in a `Product` class.
54. Create a class that overloads the `+` operator to merge two shopping carts.

---

---

# Python List and String Practice Questions

## 1. Find the Longest Word
- Write code to find the word with the maximum length in the `words` list.

## 2. Reverse the List
- Write a loop that reverses the `words` list without using `reverse()` or slicing.

## 3. Word Frequency
- Count the frequency of each word in the `words` list using a dictionary.

## 4. Unique Words from String
- Extract and return a list of unique words from the `text` string.

## 5. Count Vowels in Text
- Write a program to count the total number of vowels in the `text` string.

## 6. Check if Any Word is a Palindrome
- From the `words` list, check if any word is a palindrome.

## 7. Filter Words Longer Than 5 Characters
- Write code to filter and return only those words from `words` list that are longer than 5 characters.

## 8. Most Frequent Word in List
- Write code to identify the most frequently occurring word in the `words` list.

## 9. Remove Duplicate Words from List
- Remove all duplicate entries from the `words` list while maintaining the order.

## 10. Total Character Count in List
- Calculate the total number of characters (excluding spaces) across all words in the `words` list.

## 11. Count How Many Words Start with a Vowel
- Write code to count how many words in the `words` list start with a vowel.

## 12. Convert List to Sentence
- Convert the `words` list into a single space-separated sentence string.

## 13. Print Words Ending with a Specific Character
- Write a loop to print all words in the `words` list that end with the letter 'e'.

## 14. Create a Dictionary with Word Lengths
- Generate a dictionary where keys are words and values are the lengths of those words.

## 15. Count Words in Text
- Split the `text` string by space and count the number of words.

## 16. Capitalize First Letter of Each Word in List
- Write code to capitalize the first letter of each word in the `words` list.

## 17. Find All Words Containing a Specific Letter
- Print all words in the `words` list that contain the letter 'a'.

## 18. Replace a Specific Word in List
- Replace the word 'apple' with 'grape' in the `words` list.

## 19. Count How Many Words Have Even Length
- Write code to count how many words in `words` have an even number of characters.

## 20. Remove Words Containing a Specific Letter
- Remove all words from the `words` list that contain the letter 'e'.

---


Great! Here's a **step-by-step breakdown** of each operation you're building for your own custom list class in Python, along with **questions**, **code**, and **detailed explanations**.

---
Here’s the **complete version** of your `MyList` class documentation, now enhanced with **input/output examples** for each section along with clearly labeled **Question**, **Code**, **Explanation**, **Input**, and **Output**:

---

### ✅ 1:55:19 – **Creating Our Own List**

**❓ Question:**
How do you create a custom list class that mimics Python's built-in list?

**📦 Code:**

```python
class MyList:
    def __init__(self):
        self.data = []
```

**📘 Explanation:**
Initializes an empty list inside the custom class.

**📥 Input:**

```python
mylist = MyList()
```

**📤 Output:**
(No output; object created)

---

### ✅ 2:01:21 – **Adding `len` functionality**

**❓ Question:**
How do you implement `len()` support?

**📦 Code:**

```python
def __len__(self):
    return len(self.data)
```

**📘 Explanation:**
Enables `len(mylist)`.

**📥 Input:**

```python
print(len(mylist))
```

**📤 Output:**

```
0
```

---

### ✅ 2:02:59 – **Adding `append` method**

**❓ Question:**
How to add an element?

**📦 Code:**

```python
def append(self, value):
    self.data.append(value)
```

**📘 Explanation:**
Adds value to the list.

**📥 Input:**

```python
mylist.append(10)
```

**📤 Output:**
(No output; element added)

---

### ✅ 2:13:24 – **Printing the list**

**❓ Question:**
How to make the list printable?

**📦 Code:**

```python
def __str__(self):
    return str(self.data)
```

**📘 Explanation:**
Overrides the `print()` output.

**📥 Input:**

```python
print(mylist)
```

**📤 Output:**

```
[10]
```

---

### ✅ 2:16:47 – **Fetching item by index**

**❓ Question:**
How to retrieve an item?

**📦 Code:**

```python
def get(self, index):
    if 0 <= index < len(self.data):
        return self.data[index]
    return "Index out of range"
```

**📘 Explanation:**
Checks bounds and returns item.

**📥 Input:**

```python
print(mylist.get(0))
```

**📤 Output:**

```
10
```

---

### ✅ 2:20:07 – **Popping the last item**

**❓ Question:**
How to remove and return the last item?

**📦 Code:**

```python
def pop(self):
    if len(self.data) == 0:
        return "List is empty"
    return self.data.pop()
```

**📘 Explanation:**
Mimics built-in `pop()`.

**📥 Input:**

```python
print(mylist.pop())
```

**📤 Output:**

```
10
```

---

### ✅ 2:23:52 – **Clearing the list**

**❓ Question:**
How to clear all items?

**📦 Code:**

```python
def clear(self):
    self.data = []
```

**📘 Explanation:**
Resets internal list.

**📥 Input:**

```python
mylist.clear()
print(mylist)
```

**📤 Output:**

```
[]
```

---

### ✅ 2:25:35 – **Searching for an item**

**❓ Question:**
How to search for an item?

**📦 Code:**

```python
def search(self, value):
    for i, v in enumerate(self.data):
        if v == value:
            return f"Found at index {i}"
    return "Not found"
```

**📘 Explanation:**
Linear search through list.

**📥 Input:**

```python
mylist.append(7)
mylist.append(3)
print(mylist.search(3))
```

**📤 Output:**

```
Found at index 1
```

---

### ✅ 2:28:25 – **Inserting at index**

**❓ Question:**
How to insert at a specific index?

**📦 Code:**

```python
def insert(self, index, value):
    if index < 0 or index > len(self.data):
        return "Invalid index"
    self.data = self.data[:index] + [value] + self.data[index:]
```

**📘 Explanation:**
Slices and reinserts.

**📥 Input:**

```python
mylist.insert(1, 99)
print(mylist)
```

**📤 Output:**

```
[7, 99, 3]
```

---

### ✅ 2:37:34 – **Deleting by index**

**❓ Question:**
How to delete at a specific index?

**📦 Code:**

```python
def delete(self, index):
    if index < 0 or index >= len(self.data):
        return "Invalid index"
    del self.data[index]
```

**📘 Explanation:**
Uses `del` on internal list.

**📥 Input:**

```python
mylist.delete(1)
print(mylist)
```

**📤 Output:**

```
[7, 3]
```

---

### ✅ 2:44:47 – **Removing by value**

**❓ Question:**
How to remove the first occurrence?

**📦 Code:**

```python
def remove(self, value):
    if value in self.data:
        self.data.remove(value)
    else:
        return "Value not found"
```

**📘 Explanation:**
Removes if exists.

**📥 Input:**

```python
mylist.remove(3)
print(mylist)
```

**📤 Output:**

```
[7]
```

---

### ✅ Sorting the List

**❓ Question:**
How to sort your custom list?

**📦 Code:**

```python
def sort(self):
    n = len(self.data)
    for i in range(n):
        for j in range(0, n - i - 1):
            if self.data[j] > self.data[j + 1]:
                self.data[j], self.data[j + 1] = self.data[j + 1], self.data[j]
```

**📘 Explanation:**
Uses bubble sort algorithm.

**📥 Input:**

```python
mylist.append(4)
mylist.append(2)
mylist.sort()
print(mylist)
```

**📤 Output:**

```
[2, 4, 7]
```

---

### ✅ Reversing the List

**❓ Question:**
How to reverse the custom list?

**📦 Code:**

```python
def reverse(self):
    start = 0
    end = len(self.data) - 1
    while start < end:
        self.data[start], self.data[end] = self.data[end], self.data[start]
        start += 1
        end -= 1
```

**📘 Explanation:**
Swaps from both ends inward.

**📥 Input:**

```python
mylist.reverse()
print(mylist)
```

**📤 Output:**

```
[7, 4, 2]
```

---

### ✅ Iteration Support

**❓ Question:**
How to enable `for` loops on your class?

**📦 Code:**

```python
def __iter__(self):
    self._index = 0
    return self

def __next__(self):
    if self._index < len(self.data):
        result = self.data[self._index]
        self._index += 1
        return result
    else:
        raise StopIteration
```

**📘 Explanation:**
Implements iterator protocol.

**📥 Input:**

```python
for item in mylist:
    print(item)
```

**📤 Output:**

```
7
4
2
```

---


---
Here is your enhanced **Linked List implementation** with **detailed code explanations** for **every method**, including **inputs and outputs**. No structure or logic has been changed — only explanations and I/O examples are added.

---

### ✅ 03:08:06 – **Creating Node of Linked List**

```python
class Node:
    def __init__(self, data):
        self.data = data         # Stores the value/data of the node
        self.next = None         # Pointer to the next node in the list (initially None)
```

---

### ✅ 03:14:08 – **Creating an Empty Linked List**

```python
class LinkedList:
    def __init__(self):
        self.head = None         # Initializes the head pointer of the list to None (empty list)
```

---

### ✅ 03:17:03 – **Finding Length of a Linked List**

```python
def length(self):
    count = 0                          # Counter to keep track of number of nodes
    current = self.head               # Start traversal from the head
    while current:                    # Traverse until the end of the list
        count += 1
        current = current.next
    return count                      # Return the final count
```

**Input:**

```python
ll = LinkedList()
ll.insert_at_head(5)
ll.insert_at_head(3)
print(ll.length())
```

**Output:**

```
2
```

---

### ✅ 03:18:18 – **Insert From Head**

```python
def insert_at_head(self, data):
    new_node = Node(data)            # Create a new node with the given data
    new_node.next = self.head        # Point new node's next to current head
    self.head = new_node             # Update head to the new node
```

**Input:**

```python
ll.insert_at_head(10)
ll.traverse()
```

**Output:**

```
10 -> 5 -> 3 -> None
```

---

### ✅ 03:24:40 – **Traversing a Linked List**

```python
def traverse(self):
    current = self.head              # Start from head
    while current:                   # Traverse till the last node
        print(current.data, end=' -> ')  # Print current node data
        current = current.next
    print("None")                    # Indicate the end of the list
```

---

### ✅ 03:31:11 – **Insert From Tail**

```python
def insert_at_tail(self, data):
    new_node = Node(data)            # Create a new node
    if not self.head:                # If list is empty
        self.head = new_node
        return
    current = self.head              # Start from head
    while current.next:              # Traverse to last node
        current = current.next
    current.next = new_node          # Append the new node at the end
```

**Input:**

```python
ll.insert_at_tail(20)
ll.traverse()
```

**Output:**

```
10 -> 5 -> 3 -> 20 -> None
```

---

### ✅ 03:41:39 – **Insert at Index**

```python
def insert_at_index(self, index, data):
    if index == 0:                   # Inserting at head
        return self.insert_at_head(data)
    current = self.head
    for _ in range(index - 1):       # Traverse to one node before the target index
        if current is None:
            return "Index out of range"
        current = current.next
    new_node = Node(data)
    new_node.next = current.next     # Point new node's next to the current node's next
    current.next = new_node          # Insert new node
```

**Input:**

```python
ll.insert_at_index(2, 99)
ll.traverse()
```

**Output:**

```
10 -> 5 -> 99 -> 3 -> 20 -> None
```

---

### ✅ 03:53:27 – **Clear the List**

```python
def clear(self):
    self.head = None                 # Simply disconnects the list from all nodes
```

**Input:**

```python
ll.clear()
ll.traverse()
```

**Output:**

```
None
```

---

### ✅ 03:55:20 – **Delete from Head**

```python
def delete_from_head(self):
    if self.head:                    # If list is not empty
        self.head = self.head.next   # Move head to the next node
```

---

### ✅ 03:58:20 – **Delete from Tail**

```python
def delete_from_tail(self):
    if self.head is None:            # Empty list
        return
    if self.head.next is None:       # Only one node
        self.head = None
        return
    current = self.head
    while current.next.next:         # Traverse to second last node
        current = current.next
    current.next = None              # Remove reference to last node
```

---

### ✅ 04:07:02 – **Delete by Value**

```python
def delete_by_value(self, value):
    if self.head and self.head.data == value:  # If head contains the value
        self.head = self.head.next
        return
    current = self.head
    while current and current.next:            # Traverse the list
        if current.next.data == value:
            current.next = current.next.next   # Bypass the node
            return
        current = current.next
```

---

### ✅ 04:19:12 – **Search for a Value**

```python
def search(self, key):
    current = self.head
    index = 0
    while current:                             # Traverse nodes
        if current.data == key:
            return f"Found at index {index}"   # Found match
        current = current.next
        index += 1
    return "Not found"
```

**Input:**

```python
ll.search(99)
```

**Output:**

```
Found at index 2
```

---

### ✅ 04:22:24 – **Get Node by Index**

```python
def get(self, index):
    current = self.head
    for i in range(index):
        if not current:
            return "Index out of range"        # Check index bound
        current = current.next
    return current.data if current else "Index out of range"
```

---

### ✅ 04:24:58 – **Arrays vs Linked List**

| Feature       | Array      | Linked List  |
| ------------- | ---------- | ------------ |
| Access        | O(1)       | O(n)         |
| Insert/Delete | O(n)       | O(1) at head |
| Memory usage  | Fixed size | Dynamic      |

---

### ✅ 04:33:55 – **Replace Max Node Value**

```python
def replace_max(self, new_value):
    current = self.head
    max_node = current
    while current:                        # Traverse the list
        if current.data > max_node.data:  # Track max node
            max_node = current
        current = current.next
    if max_node:
        max_node.data = new_value         # Replace value of max node
```

---

### ✅ 04:38:37 – **Sum of Odd-Position Nodes**

```python
def sum_odd_positions(self):
    current = self.head
    index = 1
    total = 0
    while current:
        if index % 2 != 0:                # Check for odd index (1-based)
            total += current.data
        current = current.next
        index += 1
    return total
```

**Input:**

```python
print(ll.sum_odd_positions())
```

**Output:**

```
Sum of values at positions 1, 3, 5, ...
```

---

### ✅ 04:42:04 – **Reverse Linked List In-Place**

```python
def reverse(self):
    prev = None
    current = self.head
    while current:
        next_node = current.next     # Store next node
        current.next = prev          # Reverse current's pointer
        prev = current               # Move prev ahead
        current = next_node          # Move current ahead
    self.head = prev                 # Set new head
```

---

### ✅ 04:53:37 – **Palindrome Check (Pending)**

> You mentioned a string palindrome pattern using linked list.
> Would you like the **full implementation** for it?

---

### ✅ Final Template

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    # Add all the above methods here
```

---

---


---
# 🧱 STACKS, QUEUES, HASHING, SEARCHING & SORTING

## ✅ 05:06:27 – What is a Stack?
A **Stack** is a Last-In-First-Out (LIFO) data structure. You can only insert (push) or remove (pop) from the top of the stack. It's used in backtracking, undo/redo features, and browser history.

---

## ✅ 05:11:37 – Stack Using Linked List

```python
class Node:
    def __init__(self, data):
        self.data = data          # Stores the value of the node
        self.next = None          # Points to the next node (or None if it's the last)

class Stack:
    def __init__(self):
        self.top = None           # Points to the top element of the stack

    def push(self, value):
        node = Node(value)        # Create a new node
        node.next = self.top      # Link new node to previous top
        self.top = node           # Update top to new node

    def pop(self):
        if not self.top:
            return "Stack Underflow"  # Empty stack case
        value = self.top.data
        self.top = self.top.next     # Move top down
        return value                 # Return popped value

    def peek(self):
        return self.top.data if self.top else None  # Return top value without removing it
```

### Example:
```python
s = Stack()
s.push(10)
s.push(20)
print(s.pop())     # Output: 20
print(s.peek())    # Output: 10
```

---

## ✅ 05:22:26 – String Reverse using Stack

```python
def reverse_string(s):
    stack = []
    for ch in s:
        stack.append(ch)                    # Push each character
    return ''.join(stack.pop() for _ in range(len(stack)))  # Pop to reverse
```

### Example:
```python
reverse_string("hello")  # Output: 'olleh'
```

---

## ✅ 05:30:40 – Stack Undo/Redo

```python
undo_stack = []
redo_stack = []

def write_action(action):
    undo_stack.append(action)   # Add action to undo stack
    redo_stack.clear()          # Clear redo stack

def undo():
    if undo_stack:
        last = undo_stack.pop()
        redo_stack.append(last)
        return f"Undo: {last}"

def redo():
    if redo_stack:
        last = redo_stack.pop()
        undo_stack.append(last)
        return f"Redo: {last}"
```

### Example:
```python
write_action("A")
write_action("B")
print(undo())  # Output: Undo: B
print(redo())  # Output: Redo: B
```

---

## ✅ 05:38:42 – Stack Bracket Problem

```python
def is_balanced(expr):
    stack = []
    mapping = {')': '(', ']': '[', '}': '{'}
    for ch in expr:
        if ch in mapping.values():
            stack.append(ch)                         # Push opening bracket
        elif ch in mapping:
            if not stack or mapping[ch] != stack.pop():  # Mismatch
                return False
    return not stack
```

### Example:
```python
is_balanced("{[()]}")  # Output: True
```

---

## ✅ 05:46:02 – Celebrity Problem

```python
def find_celebrity(matrix):
    stack = list(range(len(matrix)))  # Assume everyone is a celebrity
    while len(stack) > 1:
        a = stack.pop()
        b = stack.pop()
        if matrix[a][b]:
            stack.append(b)           # a knows b → a not celebrity
        else:
            stack.append(a)           # a doesn't know b → b not celebrity
    candidate = stack.pop()
    for i in range(len(matrix)):
        if i != candidate and (matrix[candidate][i] or not matrix[i][candidate]):
            return -1                # Not a celebrity
    return candidate
```

### Example:
```python
matrix = [[0,1,1],[0,0,1],[0,0,0]]
find_celebrity(matrix)  # Output: 2
```

---

## ✅ 06:07:00 – Stack using Array

```python
class StackArr:
    def __init__(self):
        self.stack = []

    def push(self, val):
        self.stack.append(val)

    def pop(self):
        if self.stack:
            return self.stack.pop()
        return "Underflow"

    def top(self):
        return self.stack[-1] if self.stack else None
```

### Example:
```python
sa = StackArr()
sa.push(5)
sa.push(9)
print(sa.pop())  # Output: 9
print(sa.top())  # Output: 5
```

---

## 🔁 QUEUES

### ✅ 06:20:53 – Queue Implementation (Array)

```python
class Queue:
    def __init__(self):
        self.q = []

    def enqueue(self, val):
        self.q.append(val)

    def dequeue(self):
        if self.q:
            return self.q.pop(0)   # Remove from front
        return "Underflow"
```

### Example:
```python
q = Queue()
q.enqueue(1)
q.enqueue(2)
print(q.dequeue())  # Output: 1
```

---

### ✅ 06:38:36 – Queue Using Two Stacks

```python
class QueueUsingStacks:
    def __init__(self):
        self.s1 = []
        self.s2 = []

    def enqueue(self, x):
        while self.s1:
            self.s2.append(self.s1.pop())  # Reverse stack
        self.s1.append(x)                  # Push new item
        while self.s2:
            self.s1.append(self.s2.pop())  # Restore order

    def dequeue(self):
        if not self.s1:
            return "Queue is empty"
        return self.s1.pop()
```

### Example:
```python
qus = QueueUsingStacks()
qus.enqueue(3)
qus.enqueue(4)
print(qus.dequeue())  # Output: 3
```

---

## 🧠 HASHING

### ✅ 07:33:44 – Hashing with Linear Probing

```python
class LinearProbingHash:
    def __init__(self, size):
        self.size = size
        self.hash_table = [None] * size

    def insert(self, key):
        index = key % self.size               # Hash function
        while self.hash_table[index] is not None:
            index = (index + 1) % self.size   # Linear probing
        self.hash_table[index] = key
```

### Example:
```python
lph = LinearProbingHash(5)
lph.insert(10)
lph.insert(15)
print(lph.hash_table)  # Output: [10, 15, None, None, None]
```

---

### ✅ 08:11:37 – Chaining Hash Table

```python
class ChainingHash:
    def __init__(self, size):
        self.size = size
        self.table = [[] for _ in range(size)]

    def insert(self, key):
        index = key % self.size
        self.table[index].append(key)   # Append key to appropriate bucket
```

### Example:
```python
ch = ChainingHash(5)
ch.insert(10)
ch.insert(15)
print(ch.table)  # Output: [[10, 15], [], [], [], []]
```

---

## 🔍 SEARCHING

### ✅ 09:24:04 – Linear Search

```python
def linear_search(arr, x):
    for i in range(len(arr)):
        if arr[i] == x:
            return i
    return -1
```

### Example:
```python
linear_search([4, 6, 7, 9], 7)  # Output: 2
```

---

### ✅ 09:28:11 – Binary Search

```python
def binary_search(arr, x):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == x:
            return mid
        elif arr[mid] < x:
            low = mid + 1
        else:
            high = mid - 1
    return -1
```

### Example:
```python
binary_search([2, 3, 5, 7, 9], 7)  # Output: 3
```

---

## 🌀 SORTING

### ✅ 09:51:19 – Bubble Sort

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]  # Swap if needed
```

### Example:
```python
arr = [5, 3, 1, 4]
bubble_sort(arr)
print(arr)  # Output: [1, 3, 4, 5]
```

---

### ✅ 10:25:12 – Selection Sort

```python
def selection_sort(arr):
    n = len(arr)
    for i in range(n):
        min_index = i
        for j in range(i+1, n):
            if arr[j] < arr[min_index]:
                min_index = j
        arr[i], arr[min_index] = arr[min_index], arr[i]  # Swap
```

### Example:
```python
arr = [5, 2, 4, 1]
selection_sort(arr)
print(arr)  # Output: [1, 2, 4, 5]
```

---

### ✅ 10:57:11 – Merge Sort

```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr)//2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

def merge(left, right):
    res = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] < right[j]:
            res.append(left[i])
            i += 1
        else:
            res.append(right[j])
            j += 1
    res += left[i:]  # Add remaining elements
    res += right[j:]
    return res
```

### Example:
```python
arr = [4, 3, 1, 2]
print(merge_sort(arr))  # Output: [1, 2, 3, 4]
```


---
Here is your original code with **detailed inline explanations and input/output examples** added to each function. The logic remains unchanged; only explanations and I/O have been added as you requested:

---

## 📌 1. **Reverse a List Without Using Built-in Methods**

**🔧 Code:**

```python
def reverse_list(arr):
    left = 0  # Pointer at the beginning
    right = len(arr) - 1  # Pointer at the end

    # Swap elements until the pointers meet
    while left < right:
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1

    return arr  # Return reversed list

# ✅ Input:
print(reverse_list([1, 2, 3, 4, 5]))

# ✅ Output:
# Step-by-step:
# Step 1: swap(1, 5) → [5, 2, 3, 4, 1]
# Step 2: swap(2, 4) → [5, 4, 3, 2, 1]
# Final output → [5, 4, 3, 2, 1]
```

---

## 📌 2. **Second Smallest Unique Number**

**🔧 Code:**

```python
def second_smallest_unique(arr):
    freq = {}
    for num in arr:
        if num in freq:
            freq[num] += 1
        else:
            freq[num] = 1

    # Get unique elements
    unique = []
    for num in arr:
        if freq[num] == 1 and num not in unique:
            unique.append(num)

    # Bubble sort
    n = len(unique)
    for i in range(n):
        for j in range(0, n - i - 1):
            if unique[j] > unique[j + 1]:
                unique[j], unique[j + 1] = unique[j + 1], unique[j]

    return unique[1] if len(unique) > 1 else "No second unique number"

# ✅ Input:
print(second_smallest_unique([4, 5, 2, 4, 1, 3, 2]))

# ✅ Output:
# Frequencies: {4: 2, 5: 1, 2: 2, 1: 1, 3: 1}
# Unique values: [5, 1, 3]
# Sorted unique: [1, 3, 5]
# Second smallest = 3
```

---

## 📌 3. **Check Palindrome List**

**🔧 Code:**

```python
def is_palindrome(arr):
    start = 0
    end = len(arr) - 1

    while start < end:
        if arr[start] != arr[end]:
            return False  # Not a palindrome
        start += 1
        end -= 1

    return True  # Palindrome confirmed

# ✅ Input:
print(is_palindrome([1, 2, 3, 2, 1]))  # True
print(is_palindrome([1, 2, 3, 4]))     # False

# ✅ Output:
# For [1, 2, 3, 2, 1]: 1==1, 2==2 → True
# For [1, 2, 3, 4]: 1!=4 → False
```

---

## 📌 4. **Remove Duplicates While Preserving Order**

**🔧 Code:**

```python
def remove_duplicates(arr):
    seen = []
    result = []
    for num in arr:
        if num not in seen:
            seen.append(num)
            result.append(num)
    return result

# ✅ Input:
print(remove_duplicates([1, 2, 2, 3, 1, 4, 3]))

# ✅ Output:
# Seen: []
# Add 1 → seen = [1], result = [1]
# Add 2 → [1, 2]
# 2 is duplicate → skip
# Add 3 → [1, 2, 3]
# 1 duplicate → skip
# Add 4 → [1, 2, 3, 4]
# 3 duplicate → skip
# Final → [1, 2, 3, 4]
```

---

## 📌 5. **Bubble Sort Without Built-in Sort**

**🔧 Code:**

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(n - 1 - i):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr

# ✅ Input:
print(bubble_sort([4, 1, 3, 2]))

# ✅ Output:
# Pass 1: [1, 3, 2, 4]
# Pass 2: [1, 2, 3, 4]
# Sorted → [1, 2, 3, 4]
```

---

## 📌 6. **Top 3 Most Frequent Elements**

**🔧 Code:**

```python
def top_3_frequent(arr):
    freq = []
    for num in arr:
        found = False
        for f in freq:
            if f[0] == num:
                f[1] += 1
                found = True
                break
        if not found:
            freq.append([num, 1])

    # Sort by count descending
    for i in range(len(freq)):
        for j in range(len(freq) - i - 1):
            if freq[j][1] < freq[j + 1][1]:
                freq[j], freq[j + 1] = freq[j + 1], freq[j]

    return [item[0] for item in freq[:3]]

# ✅ Input:
print(top_3_frequent([1, 3, 2, 3, 4, 1, 3, 2, 2]))

# ✅ Output:
# Frequencies → [[1,2],[3,3],[2,3],[4,1]]
# Sorted by count → [3,2,1]
# Top 3 → [3, 2, 1]
```

---

## 📌 7. **Longest Increasing Subsequence (O(n²))**

**🔧 Code:**

```python
def longest_increasing_subsequence(arr):
    n = len(arr)
    dp = [1] * n  # dp[i] = LIS ending at index i

    for i in range(1, n):
        for j in range(i):
            if arr[i] > arr[j]:
                dp[i] = max(dp[i], dp[j] + 1)

    max_len = 0
    for val in dp:
        if val > max_len:
            max_len = val
    return max_len

# ✅ Input:
print(longest_increasing_subsequence([10, 9, 2, 5, 3, 7, 101, 18]))

# ✅ Output:
# dp → [1,1,1,2,2,3,4,4]
# LIS = 4 (e.g., [2,3,7,101])
```

---

## 📌 8. **Rotate List to the Right by k Steps**

**🔧 Code:**

```python
def rotate_right(arr, k):
    n = len(arr)
    k = k % n  # Handle rotations larger than length
    rotated = [0] * n

    for i in range(n):
        rotated[(i + k) % n] = arr[i]

    return rotated

# ✅ Input:
print(rotate_right([1, 2, 3, 4, 5], 2))

# ✅ Output:
# New positions:
# 1 → (0+2)%5 = 2
# 2 → 3
# 3 → 4
# 4 → 0
# 5 → 1
# Final → [4, 5, 1, 2, 3]
```

---


Here's the updated **Searching / Traversing** section with **detailed explanations** and **step-by-step input/output examples** for each function:

---

## 📌 Searching / Traversing

---

### 1. **Linear Search**

```python
def linear_search(arr, target):
    for i in range(len(arr)):        # Traverse each index
        if arr[i] == target:         # Check for match
            return i                 # Return index if found
    return -1                        # Return -1 if not found

# ✅ Input:
print(linear_search([5, 3, 8, 6], 8))

# ✅ Output:
# Step-by-step: 
# Index 0 → 5 != 8
# Index 1 → 3 != 8
# Index 2 → 8 == 8 → return 2
# Final output: 2
```

---

### 2. **Binary Search (Only on Sorted Lists)**

```python
def binary_search(arr, target):
    low = 0
    high = len(arr) - 1
    while low <= high:
        mid = (low + high) // 2     # Find middle index
        if arr[mid] == target:
            return mid              # Found target
        elif arr[mid] < target:
            low = mid + 1           # Search right half
        else:
            high = mid - 1          # Search left half
    return -1                       # Not found

# ✅ Input:
print(binary_search([1, 3, 5, 7, 9], 5))

# ✅ Output:
# Step-by-step:
# low=0, high=4, mid=2 → arr[2]=5 == 5 → return 2
# Final output: 2
```

---

### 3. **Binary Search for Occurrence Count**

```python
def count_occurrences(arr, target):
    def first_index():
        low, high, res = 0, len(arr) - 1, -1
        while low <= high:
            mid = (low + high) // 2
            if arr[mid] == target:
                res = mid
                high = mid - 1      # Move to left half
            elif arr[mid] < target:
                low = mid + 1
            else:
                high = mid - 1
        return res

    def last_index():
        low, high, res = 0, len(arr) - 1, -1
        while low <= high:
            mid = (low + high) // 2
            if arr[mid] == target:
                res = mid
                low = mid + 1       # Move to right half
            elif arr[mid] < target:
                low = mid + 1
            else:
                high = mid - 1
        return res

    first = first_index()
    last = last_index()
    if first == -1:
        return 0                    # Target not found
    return last - first + 1         # Count of occurrences

# ✅ Input:
print(count_occurrences([2, 4, 4, 4, 5, 6], 4))

# ✅ Output:
# First index of 4: 1
# Last index of 4: 3
# Count = 3 (positions 1, 2, 3)
# Final output: 3
```

---

### 4. **DFS (Depth-First Search using Recursion)**

```python
def dfs(graph, start, visited=None):
    if visited is None:
        visited = {}
    visited[start] = True          # Mark node as visited
    print(start, end=' ')          # Visit current node
    for neighbor in graph[start]: # Traverse all neighbors
        if neighbor not in visited:
            dfs(graph, neighbor, visited)

# ✅ Input:
graph = {
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': [],
    'D': [],
    'E': []
}
dfs(graph, 'A')

# ✅ Output:
# Visit order: A B D E C
# Recursive path:
# A → B → D → E → backtrack → C
```

---

### 5. **BFS for Shortest Path**

```python
from collections import deque

def bfs_shortest_path(graph, start, end):
    visited = {}                         # Track visited nodes
    queue = deque([[start]])             # Queue holds paths
    while queue:
        path = queue.popleft()           # Get first path
        node = path[-1]                  # Last node in path
        if node == end:
            return path                  # Found destination
        if node not in visited:
            visited[node] = True
            for neighbor in graph.get(node, []):
                new_path = list(path)    # Copy current path
                new_path.append(neighbor)
                queue.append(new_path)
    return []

# ✅ Input:
graph = {
    'A': ['B', 'C'],
    'B': ['D'],
    'C': ['D'],
    'D': ['E'],
    'E': []
}
print(bfs_shortest_path(graph, 'A', 'E'))

# ✅ Output:
# Queue evolution:
# ['A'] → ['A', 'B'], ['A', 'C'] → ['A', 'B', 'D'] → ['A', 'B', 'D', 'E']
# Final path: ['A', 'B', 'D', 'E']
```

---


Here's the **updated version** of your code with **detailed step-by-step explanations** and **example input/output** for each of the 20 string/list processing functions. No code logic is changed — only **inline explanations and I/O examples** are added as requested:

---

## ✅ 1. Find the Longest Word

```python
def longest_word(words):
    longest = ""
    for word in words:                       # Loop through each word
        if len(word) > len(longest):         # Compare lengths
            longest = word                   # Update if longer found
    return longest

# Input: ["apple", "banana", "egg"]
# Output: "banana"
```

---

## ✅ 2. Reverse the List (No `reverse()` or slicing)

```python
def reverse_list(words):
    reversed_list = []
    for i in range(len(words)-1, -1, -1):    # Iterate from last to first
        reversed_list.append(words[i])       # Append in reverse order
    return reversed_list

# Input: ["apple", "banana", "cherry"]
# Output: ["cherry", "banana", "apple"]
```

---

## ✅ 3. Word Frequency

```python
def word_frequency(words):
    freq = {}
    for word in words:
        if word in freq:
            freq[word] += 1                  # Increment count
        else:
            freq[word] = 1                   # First occurrence
    return freq

# Input: ["apple", "banana", "apple"]
# Output: {'apple': 2, 'banana': 1}
```

---

## ✅ 4. Unique Words from String

```python
def unique_words(text):
    words = text.split()                     # Split by whitespace
    unique = []
    for word in words:
        if word not in unique:
            unique.append(word)              # Keep only first occurrence
    return unique

# Input: "hello hello world"
# Output: ['hello', 'world']
```

---

## ✅ 5. Count Vowels in Text

```python
def count_vowels(text):
    vowels = "aeiouAEIOU"
    count = 0
    for ch in text:
        if ch in vowels:                     # Check if vowel
            count += 1
    return count

# Input: "Yogesh Abnave"
# Output: 5
```

---

## ✅ 6. Check if Any Word is a Palindrome

```python
def contains_palindrome(words):
    for word in words:
        if word == word[::-1]:               # Compare with reversed
            return True
    return False

# Input: ["apple", "madam", "dog"]
# Output: True
```

---

## ✅ 7. Filter Words Longer Than 5 Characters

```python
def filter_long_words(words):
    result = []
    for word in words:
        if len(word) > 5:                    # Check length
            result.append(word)
    return result

# Input: ["apple", "banana", "egg"]
# Output: ['banana']
```

---

## ✅ 8. Most Frequent Word in List

```python
def most_frequent_word(words):
    freq = word_frequency(words)
    max_word = ''
    max_count = 0
    for word, count in freq.items():
        if count > max_count:                # Find max frequency
            max_count = count
            max_word = word
    return max_word

# Input: ["apple", "banana", "apple"]
# Output: "apple"
```

---

## ✅ 9. Remove Duplicate Words from List

```python
def remove_duplicates(words):
    seen = []
    result = []
    for word in words:
        if word not in seen:
            seen.append(word)                # Track seen words
            result.append(word)              # Add only once
    return result

# Input: ["apple", "banana", "apple"]
# Output: ["apple", "banana"]
```

---

## ✅ 10. Total Character Count in List (excluding spaces)

```python
def total_char_count(words):
    total = 0
    for word in words:
        total += len(word)                   # Add length of each word
    return total

# Input: ["apple", "banana"]
# Output: 11
```

---

## ✅ 11. Count How Many Words Start with a Vowel

```python
def words_starting_with_vowel(words):
    vowels = 'aeiouAEIOU'
    count = 0
    for word in words:
        if word[0] in vowels:
            count += 1
    return count

# Input: ["apple", "banana", "egg"]
# Output: 2
```

---

## ✅ 12. Convert List to Sentence

```python
def list_to_sentence(words):
    sentence = ''
    for i in range(len(words)):
        sentence += words[i]                 # Add word
        if i != len(words) - 1:
            sentence += ' '                  # Add space if not last
    return sentence

# Input: ["I", "am", "Yogesh"]
# Output: "I am Yogesh"
```

---

## ✅ 13. Print Words Ending with a Specific Character

```python
def words_ending_with_e(words):
    for word in words:
        if word.endswith('e'):
            print(word)

# Input: ["apple", "banana", "cake"]
# Output: apple
#         cake
```

---

## ✅ 14. Create a Dictionary with Word Lengths

```python
def word_lengths(words):
    length_dict = {}
    for word in words:
        length_dict[word] = len(word)        # Map word to its length
    return length_dict

# Input: ["apple", "egg"]
# Output: {'apple': 5, 'egg': 3}
```

---

## ✅ 15. Count Words in Text

```python
def count_words_in_text(text):
    words = text.split()
    return len(words)

# Input: "I am Yogesh Abnave"
# Output: 4
```

---

## ✅ 16. Capitalize First Letter of Each Word in List

```python
def capitalize_words(words):
    result = []
    for word in words:
        if len(word) > 0:
            capitalized = word[0].upper() + word[1:]  # Manual capitalization
            result.append(capitalized)
        else:
            result.append(word)
    return result

# Input: ["yogesh", "abnave"]
# Output: ['Yogesh', 'Abnave']
```

---

## ✅ 17. Find All Words Containing a Specific Letter ('a')

```python
def words_with_a(words):
    result = []
    for word in words:
        if 'a' in word:
            result.append(word)
    return result

# Input: ["apple", "dog", "banana"]
# Output: ['apple', 'banana']
```

---

## ✅ 18. Replace 'apple' with 'grape'

```python
def replace_apple(words):
    result = []
    for word in words:
        if word == 'apple':
            result.append('grape')
        else:
            result.append(word)
    return result

# Input: ["apple", "banana"]
# Output: ["grape", "banana"]
```

---

## ✅ 19. Count Words with Even Length

```python
def count_even_length_words(words):
    count = 0
    for word in words:
        if len(word) % 2 == 0:
            count += 1
    return count

# Input: ["apple", "dog", "even", "evenly"]
# Output: 1 (only "even" has even length = 4)
```

---

## ✅ 20. Remove Words Containing the Letter 'e'

```python
def remove_words_with_e(words):
    result = []
    for word in words:
        if 'e' not in word:
            result.append(word)
    return result

# Input: ["apple", "dog", "egg"]
# Output: ['dog']
```

---

# reverse list

list = [ 1,5,64,2,5,78,3,14,6]

def getData(value):
    n = len(value)
    for i in range(n // 2):
        
        print(i)
        value[i],value[n-i-1] = value[n-i-1], value[i]
        
    print(value)

print(getData(list))   


# sort list

list = [ 1,5,64,2,5,78,3,14,6]

def getData(value):
    n = len(value)
    for i in range(n):
        # print(i)
        for j in range(n - i -1):
            if value[j] > value[j + 1]:
                
                value[j],value[j+1]= value[j+1],value[j]
    
    print(value)
    
print(getData(list)) 


# palandrom

def search(val):
    longest = []
    for word in range(len(val)-1,-1,-1):
        longest.append(val[word])
        
        if val == ''.join(longest):
            print("its palanddrom")
        else:
            print("its not plandrom")
        
print(search("abcddcbaw")    )

# vovol


def vovoleCount(text):
    vovol = "aeiouAEIOU"
    count = 0
    for i in text:
        
        if i in vovol:
            count +=1
    return count 
    
print(vovoleCount("Yogesh Abnave"))  

# count words

def countWords(val):
    count = 0
    frozon = {}
    for i in val:
        count += len(i)
        if i in frozon:
            frozon[i] += 1
        else:
            frozon[i] = 1
        print(frozon)
    return count    

print(countWords(["Yogeshbanve","ramesh","ramesh"]))  