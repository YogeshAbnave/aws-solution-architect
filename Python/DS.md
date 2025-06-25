-----

Here is your original code with **detailed inline explanations and input/output examples** added to each function. The logic remains unchanged; only explanations and I/O have been added as you requested:

-----

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

-----

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

-----

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

-----

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

-----

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

-----

## 📌 6. **Top 3 Most Frequent Elements**

**🔧 Code:**

```python
def top_3_frequent(arr):
    # Manually count frequencies using a list of [item, count]
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

    # Manually sort the frequency list by count in descending order
    n = len(freq)
    for i in range(n):
        for j in range(0, n - i - 1):
            if freq[j][1] < freq[j + 1][1]:  # Compare counts (second element)
                freq[j], freq[j + 1] = freq[j + 1], freq[j]

    # Extract the top 3 elements
    result = []
    for i in range(min(3, len(freq))):
        result.append(freq[i][0])
    return result

# ✅ Input:
print(top_3_frequent([1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4]))

# ✅ Output:
# Frequencies: [[1, 2], [2, 3], [3, 2], [4, 4]]
# Sorted by frequency (desc): [[4, 4], [2, 3], [1, 2], [3, 2]]
# Top 3 elements: [4, 2, 1]
```

-----

## 📌 7. **Longest Increasing Subsequence**

**🔧 Code:**

```python
def longest_increasing_subsequence(arr):
    if not arr:
        return 0

    # dp[i] will store the length of the longest increasing subsequence ending at index i
    dp = [1] * len(arr)

    for i in range(1, len(arr)):
        for j in range(i):
            if arr[i] > arr[j]:
                dp[i] = max(dp[i], dp[j] + 1)

    return max(dp)

# ✅ Input:
print(longest_increasing_subsequence([10, 9, 2, 5, 3, 7, 101, 18]))

# ✅ Output:
# dp array evolution:
# Initial: [1, 1, 1, 1, 1, 1, 1, 1]
# After processing: [1, 1, 1, 2, 2, 3, 4, 4]
# Max value in dp is 4.
```

-----

## 📌 8. **Rotate a List to the Right by k Steps**

**🔧 Code:**

```python
def rotate_list(arr, k):
    n = len(arr)
    if n == 0:
        return arr

    k = k % n  # Handle cases where k is greater than list length

    # Perform rotation by slicing and concatenating
    return arr[n - k:] + arr[:n - k]

# ✅ Input:
print(rotate_list([1, 2, 3, 4, 5, 6, 7], 3))

# ✅ Output:
# n = 7, k = 3
# arr[7-3:] = arr[4:] = [5, 6, 7]
# arr[:7-3] = arr[:4] = [1, 2, 3, 4]
# Result: [5, 6, 7] + [1, 2, 3, 4] = [5, 6, 7, 1, 2, 3, 4]
```

-----

## 📌 9. **Check if a Given String is a Palindrome (Ignoring Case and Spaces)**

**🔧 Code:**

```python
def is_palindrome_string(s):
    # Convert to lowercase and remove spaces
    processed_s = ""
    for char in s:
        if 'a' <= char <= 'z' or 'A' <= char <= 'Z' or '0' <= char <= '9':
            processed_s += char.lower()

    # Check for palindrome
    left = 0
    right = len(processed_s) - 1
    while left < right:
        if processed_s[left] != processed_s[right]:
            return False
        left += 1
        right -= 1
    return True

# ✅ Input:
print(is_palindrome_string("A man, a plan, a canal: Panama"))
print(is_palindrome_string("race a car"))

# ✅ Output:
# "amanaplanacanalpanama" → True
# "raceacar" → False
```

-----

## 📌 10. **Count Vowels and Consonants in a Given String**

**🔧 Code:**

```python
def count_vowels_consonants(s):
    vowels = "aeiouAEIOU"
    vowel_count = 0
    consonant_count = 0

    for char in s:
        if 'a' <= char.lower() <= 'z':  # Check if it's an alphabet
            if char in vowels:
                vowel_count += 1
            else:
                consonant_count += 1
    return vowel_count, consonant_count

# ✅ Input:
print(count_vowels_consonants("Hello World"))

# ✅ Output:
# 'H': consonant, 'e': vowel, 'l': consonant, 'l': consonant, 'o': vowel
# 'W': consonant, 'o': vowel, 'r': consonant, 'l': consonant, 'd': consonant
# Vowels: 3, Consonants: 7
```

-----

## 📌 11. **Find the Longest Substring Without Repeating Characters**

**🔧 Code:**

```python
def longest_substring_without_repeating_characters(s):
    char_index_map = {}  # Stores the last seen index of each character
    max_length = 0
    start = 0  # Start of the current window

    for i, char in enumerate(s):
        if char in char_index_map and char_index_map[char] >= start:
            # If char is already in the current window, move the window start
            start = char_index_map[char] + 1
        
        char_index_map[char] = i  # Update the last seen index of the character
        max_length = max(max_length, i - start + 1) # Calculate current window length

    return max_length

# ✅ Input:
print(longest_substring_without_repeating_characters("abcabcbb"))
print(longest_substring_without_repeating_characters("bbbbb"))
print(longest_substring_without_repeating_characters("pwwkew"))

# ✅ Output:
# "abcabcbb":
# a: [0] len 1
# b: [1] len 2
# c: [2] len 3
# a: [3], a in map, char_index_map['a'] (0) >= start (0), so start = 0 + 1 = 1. len = 3-1+1 = 3.
# Result: 3 (for "abc")
#
# "bbbbb":
# b: [0] len 1
# b: [1], b in map, char_index_map['b'] (0) >= start (0), so start = 0 + 1 = 1. len = 1-1+1 = 1.
# ... repeated. Result: 1 (for "b")
#
# "pwwkew":
# p: [0] len 1
# w: [1] len 2
# w: [2], w in map, char_index_map['w'] (1) >= start (0), so start = 1 + 1 = 2. len = 2-2+1 = 1.
# k: [3] len 2 (from 'wk')
# e: [4] len 3 (from 'wke')
# w: [5], w in map, char_index_map['w'] (2) >= start (2), so start = 2 + 1 = 3. len = 5-3+1 = 3.
# Max length is 3 (from "wke" or "kew")
```

-----

## 📌 12. **Check if Two Strings Are One Edit Away**

**🔧 Code:**

```python
def is_one_edit_away(s1, s2):
    len1, len2 = len(s1), len(s2)

    if abs(len1 - len2) > 1:
        return False  # More than one edit difference in length

    if len1 == len2:
        # Check for replacement
        diff_count = 0
        for i in range(len1):
            if s1[i] != s2[i]:
                diff_count += 1
        return diff_count <= 1
    elif len1 > len2:
        # Check for deletion (s2 is shorter)
        return check_deletion(s1, s2)
    else:
        # Check for insertion (s1 is shorter)
        return check_deletion(s2, s1) # Reuse deletion logic by swapping strings

def check_deletion(s_long, s_short):
    """Helper function to check if s_short can be obtained by deleting one char from s_long."""
    i = 0 # Pointer for s_long
    j = 0 # Pointer for s_short
    diff_count = 0

    while i < len(s_long) and j < len(s_short):
        if s_long[i] != s_short[j]:
            diff_count += 1
            if diff_count > 1:
                return False
            i += 1  # Only advance long string pointer
        else:
            i += 1
            j += 1
    return diff_count <= 1 # If one character was extra in s_long, diff_count will be 1.

# ✅ Input:
print(is_one_edit_away("pale", "ple"))    # True (deletion 'a')
print(is_one_edit_away("pales", "pale"))   # True (deletion 's')
print(is_one_edit_away("pale", "bale"))    # True (replacement 'p' with 'b')
print(is_one_edit_away("pale", "bake"))    # False (two replacements)
print(is_one_edit_away("apple", "aple"))   # True
print(is_one_edit_away("apple", "apply"))  # True

# ✅ Output:
# "pale", "ple": delete 'a' from "pale" to get "ple" → True
# "pales", "pale": delete 's' from "pales" to get "pale" → True
# "pale", "bale": replace 'p' with 'b' → True
# "pale", "bake": 'p' vs 'b', 'l' vs 'k' → False
```

-----

## 📌 13. **Reverse Words in a Sentence Without Reversing Characters**

**🔧 Code:**

```python
def reverse_words(sentence):
    words = []
    current_word = []
    for char in sentence:
        if char == ' ':
            if current_word: # Add current word if not empty
                words.append("".join(current_word))
                current_word = []
            words.append(' ') # Add space as a separate element
        else:
            current_word.append(char)
    
    if current_word: # Add the last word if any
        words.append("".join(current_word))

    # Reverse the list of words (including spaces)
    left = 0
    right = len(words) - 1
    while left < right:
        words[left], words[right] = words[right], words[left]
        left += 1
        right -= 1

    return "".join(words) # Join back into a string

# ✅ Input:
print(reverse_words("hello world here"))
print(reverse_words("  Python is fun  "))

# ✅ Output:
# "hello world here" → ["hello", " ", "world", " ", "here"] → ["here", " ", "world", " ", "hello"] → "here world hello"
# "  Python is fun  " → [" ", " ", "Python", " ", "is", " ", "fun", " ", " "] → [" ", " ", "fun", " ", "is", " ", "Python", " ", " "] → "  fun is Python  "
```

-----

## 📌 14. **Find the Most Frequent Character in a String (Excluding Whitespace)**

**🔧 Code:**

```python
def most_frequent_char(s):
    char_counts = {}
    for char in s:
        if char != ' ': # Exclude whitespace
            char_counts[char] = char_counts.get(char, 0) + 1

    if not char_counts:
        return None # No non-whitespace characters

    max_count = 0
    max_char = None
    for char, count in char_counts.items():
        if count > max_count:
            max_count = count
            max_char = char
    return max_char

# ✅ Input:
print(most_frequent_char("programming is fun"))
print(most_frequent_char("   "))

# ✅ Output:
# "programming is fun":
# {p: 1, r: 2, o: 1, g: 2, a: 1, m: 2, i: 2, n: 2, s: 1, f: 1, u: 1}
# 'r' appears 2 times
# 'g' appears 2 times
# 'm' appears 2 times
# 'i' appears 2 times
# 'n' appears 2 times
# 'r' will be the first one found as max and returned.
# Output: 'r' (or 'g', 'm', 'i', 'n' depending on dictionary iteration order, but 'r' is typical for this string)
# "   ": No non-whitespace characters → None
```

-----

## 📌 15. **Write a Function That Returns the Key with the Highest Value from a Dictionary**

**🔧 Code:**

```python
def key_with_highest_value(d):
    if not d:
        return None # Handle empty dictionary

    max_key = None
    max_value = -float('inf') # Initialize with negative infinity

    for key, value in d.items():
        if value > max_value:
            max_value = value
            max_key = key
    return max_key

# ✅ Input:
print(key_with_highest_value({'a': 10, 'b': 30, 'c': 20}))
print(key_with_highest_value({}))

# ✅ Output:
# {'a': 10, 'b': 30, 'c': 20} → max_value becomes 30, max_key becomes 'b' → 'b'
# {} → None
```

-----

## 📌 16. **Merge Two Dictionaries Such That Common Keys Have Their Values Added Together**

**🔧 Code:**

```python
def merge_dictionaries_add_values(d1, d2):
    merged_dict = d1.copy() # Start with a copy of the first dictionary

    for key, value in d2.items():
        if key in merged_dict:
            merged_dict[key] += value # Add values for common keys
        else:
            merged_dict[key] = value # Add new key-value pair

    return merged_dict

# ✅ Input:
dict1 = {'a': 1, 'b': 2, 'c': 3}
dict2 = {'b': 4, 'd': 5, 'a': 10}
print(merge_dictionaries_add_values(dict1, dict2))

# ✅ Output:
# Merged Dict:
# 'a': 1 + 10 = 11
# 'b': 2 + 4 = 6
# 'c': 3 (from dict1)
# 'd': 5 (from dict2)
# Result: {'a': 11, 'b': 6, 'c': 3, 'd': 5}
```

-----

## 📌 17. **Count the Frequency of Each Character in a Given String Using a Dictionary**

**🔧 Code:**

```python
def count_char_frequency(s):
    char_freq = {}
    for char in s:
        char_freq[char] = char_freq.get(char, 0) + 1
    return char_freq

# ✅ Input:
print(count_char_frequency("hello world"))

# ✅ Output:
# h: 1, e: 1, l: 3, o: 2, ' ': 1, w: 1, r: 1, d: 1
```

-----

## 📌 18. **Group Words That Are Anagrams of Each Other Using a Dictionary**

**🔧 Code:**

```python
def group_anagrams(words):
    anagram_groups = {}
    for word in words:
        # Create a sorted tuple of characters for each word as the key
        # 'eat' -> ('a', 'e', 't')
        # 'tea' -> ('a', 'e', 't')
        sorted_word_tuple = tuple(sorted(word))
        
        if sorted_word_tuple in anagram_groups:
            anagram_groups[sorted_word_tuple].append(word)
        else:
            anagram_groups[sorted_word_tuple] = [word]
    
    return list(anagram_groups.values()) # Return list of lists of anagrams

# ✅ Input:
print(group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"]))

# ✅ Output:
# {'aet': ['eat', 'tea', 'ate'], 'ant': ['tan', 'nat'], 'abt': ['bat']}
# Result: [['eat', 'tea', 'ate'], ['tan', 'nat'], ['bat']] (order may vary)
```

-----

## 📌 19. **Implement a Function to Find the Middle Element of a Singly Linked List**

**🔧 Code:**

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def find_middle(self):
        if not self.head:
            return "List is empty"
        
        slow = self.head
        fast = self.head
        
        # Traverse with two pointers: fast moves twice as fast as slow
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            
        return slow.data # When fast reaches end, slow is at middle

# ✅ Input:
ll_even = LinkedList()
ll_even.append(1)
ll_even.append(2)
ll_even.append(3)
ll_even.append(4)
print(ll_even.find_middle()) # Should be 3 (second middle for even)

ll_odd = LinkedList()
ll_odd.append(1)
ll_odd.append(2)
ll_odd.append(3)
ll_odd.append(4)
ll_odd.append(5)
print(ll_odd.find_middle()) # Should be 3

# ✅ Output:
# For [1, 2, 3, 4]: slow=1, fast=1 -> slow=2, fast=3 -> slow=3, fast=None. Returns 3.
# For [1, 2, 3, 4, 5]: slow=1, fast=1 -> slow=2, fast=3 -> slow=3, fast=5. Returns 3.
```

-----

## 📌 20. **Detect if a Linked List Has a Cycle (Loop) in It**

**🔧 Code:**

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def has_cycle(self):
        if not self.head:
            return False
        
        slow = self.head
        fast = self.head
        
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            if slow == fast: # If pointers meet, there's a cycle
                return True
                
        return False # No cycle found

# ✅ Input:
ll_no_cycle = LinkedList()
ll_no_cycle.append(1)
ll_no_cycle.append(2)
ll_no_cycle.append(3)
print(ll_no_cycle.has_cycle()) # False

ll_cycle = LinkedList()
ll_cycle.append(1)
ll_cycle.append(2)
ll_cycle.append(3)
ll_cycle.head.next.next.next = ll_cycle.head.next # Creates a cycle: 3 points to 2
print(ll_cycle.has_cycle()) # True

# ✅ Output:
# For no cycle: slow and fast will never meet. Returns False.
# For cycle (1->2->3->2):
# Initial: slow=1, fast=1
# 1st loop: slow=2, fast=3
# 2nd loop: slow=3, fast=2 (fast.next.next is 2, which is slow)
# slow == fast, returns True.
```

-----

## 📌 21. **Reverse a Singly Linked List Using Iteration**

**🔧 Code:**

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def traverse(self):
        current = self.head
        nodes = []
        while current:
            nodes.append(str(current.data))
            current = current.next
        print(" -> ".join(nodes) + " -> None")

    def reverse(self):
        prev = None
        current = self.head
        while current:
            next_node = current.next # Store next node
            current.next = prev     # Reverse current node's pointer
            prev = current          # Move prev to current node
            current = next_node     # Move current to next node
        self.head = prev            # New head is the old tail (prev)

# ✅ Input:
ll = LinkedList()
ll.append(1)
ll.append(2)
ll.append(3)
ll.append(4)
print("Original List:")
ll.traverse()
ll.reverse()
print("Reversed List:")
ll.traverse()

# ✅ Output:
# Original List:
# 1 -> 2 -> 3 -> 4 -> None
# Reversed List:
# 4 -> 3 -> 2 -> 1 -> None
```

-----

## 📌 22. **Merge Two Sorted Linked Lists into a Single Sorted Linked List**

**🔧 Code:**

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def traverse(self):
        current = self.head
        nodes = []
        while current:
            nodes.append(str(current.data))
            current = current.next
        print(" -> ".join(nodes) + " -> None")

def merge_sorted_lists(l1_head, l2_head):
    dummy_head = Node(0) # Dummy node to simplify handling the head of the merged list
    current = dummy_head

    while l1_head and l2_head:
        if l1_head.data <= l2_head.data:
            current.next = l1_head
            l1_head = l1_head.next
        else:
            current.next = l2_head
            l2_head = l2_head.next
        current = current.next # Move current pointer of the merged list

    # Append remaining nodes from either list
    if l1_head:
        current.next = l1_head
    elif l2_head:
        current.next = l2_head
        
    return dummy_head.next # Return the actual head of the merged list

# ✅ Input:
ll1 = LinkedList()
ll1.append(1)
ll1.append(3)
ll1.append(5)
print("List 1:")
ll1.traverse()

ll2 = LinkedList()
ll2.append(2)
ll2.append(4)
ll2.append(6)
print("List 2:")
ll2.traverse()

merged_head = merge_sorted_lists(ll1.head, ll2.head)
merged_list = LinkedList() # Create a new LinkedList object for the merged head
merged_list.head = merged_head
print("Merged List:")
merged_list.traverse()

# ✅ Output:
# List 1:
# 1 -> 3 -> 5 -> None
# List 2:
# 2 -> 4 -> 6 -> None
# Merged List:
# 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> None
```

-----

## 📌 23. **Write a Recursive Function to Compute the Factorial of a Number**

**🔧 Code:**

```python
def factorial_recursive(n):
    if n < 0:
        return "Factorial not defined for negative numbers"
    if n == 0:
        return 1 # Base case: factorial of 0 is 1
    else:
        return n * factorial_recursive(n - 1) # Recursive step

# ✅ Input:
print(factorial_recursive(5))
print(factorial_recursive(0))
print(factorial_recursive(-3))

# ✅ Output:
# factorial_recursive(5) → 5 * factorial_recursive(4)
#                       → 5 * (4 * factorial_recursive(3))
#                       → ...
#                       → 5 * 4 * 3 * 2 * 1 = 120
# factorial_recursive(0) → 1
# factorial_recursive(-3) → "Factorial not defined for negative numbers"
```

-----

## 📌 24. **Generate the nth Fibonacci Number Using Recursion with Memoization**

**🔧 Code:**

```python
def fibonacci_memoization(n, memo={}):
    if n <= 0:
        return 0
    if n == 1:
        return 1
    if n in memo:
        return memo[n] # Return cached result

    memo[n] = fibonacci_memoization(n - 1, memo) + fibonacci_memoization(n - 2, memo)
    return memo[n]

# ✅ Input:
print(fibonacci_memoization(10))
print(fibonacci_memoization(0))
print(fibonacci_memoization(1))

# ✅ Output:
# fibonacci_memoization(10):
# Calculates F(8) and F(9), stores them.
# Calculates F(7) and F(8), F(8) is already cached.
# ... efficiently computes F(10) which is 55.
# fibonacci_memoization(0) → 0
# fibonacci_memoization(1) → 1
```

-----

## 📌 25. **Count the Number of Paths from the Top-Left to the Bottom-Right in a Grid Using Recursion**

**🔧 Code:**

```python
def count_paths(m, n, memo={}):
    """
    Counts unique paths from (0,0) to (m-1, n-1) in an m x n grid.
    Only moves right or down are allowed.
    """
    if (m, n) in memo:
        return memo[(m, n)]

    # Base cases
    if m == 1 or n == 1: # If it's a 1xN or Nx1 grid, only one path
        return 1
    
    # Recursive step: sum of paths from moving right and moving down
    memo[(m, n)] = count_paths(m - 1, n, memo) + count_paths(m, n - 1, memo)
    return memo[(m, n)]

# ✅ Input:
print(count_paths(3, 3)) # For a 3x3 grid (from (0,0) to (2,2))
print(count_paths(1, 5)) # For a 1x5 grid

# ✅ Output:
# count_paths(3, 3):
# paths(3,3) = paths(2,3) + paths(3,2)
# paths(2,3) = paths(1,3) + paths(2,2) = 1 + paths(2,2)
# paths(3,2) = paths(2,2) + paths(3,1) = paths(2,2) + 1
# paths(2,2) = paths(1,2) + paths(2,1) = 1 + 1 = 2
# So, paths(2,3) = 1 + 2 = 3
# And, paths(3,2) = 2 + 1 = 3
# Final paths(3,3) = 3 + 3 = 6
#
# count_paths(1, 5) → 1 (a straight line)
```

-----

## 📌 26. **Implement a Linear Search Function and Return the Index of the Element**

**🔧 Code:**

```python
def linear_search(arr, target):
    for i in range(len(arr)):
        if arr[i] == target:
            return i # Return index if found
    return -1 # Return -1 if not found

# ✅ Input:
print(linear_search([10, 20, 30, 40, 50], 30))
print(linear_search([1, 5, 9, 13], 7))

# ✅ Output:
# For [10, 20, 30, 40, 50], target 30: Iterates until index 2, finds 30. Returns 2.
# For [1, 5, 9, 13], target 7: Iterates through all, not found. Returns -1.
```

-----

## 📌 27. **Implement Binary Search on a Sorted List Without Using Built-in Search Methods**

**🔧 Code:**

```python
def binary_search_manual(arr, target):
    low = 0
    high = len(arr) - 1

    while low <= high:
        mid = (low + high) // 2 # Calculate middle index
        
        if arr[mid] == target:
            return mid # Target found
        elif arr[mid] < target:
            low = mid + 1 # Search in the right half
        else:
            high = mid - 1 # Search in the left half
            
    return -1 # Target not found

# ✅ Input:
print(binary_search_manual([10, 20, 30, 40, 50], 30))
print(binary_search_manual([1, 5, 9, 13], 7))

# ✅ Output:
# For [10, 20, 30, 40, 50], target 30:
# low=0, high=4, mid=2 (arr[2]=30). Returns 2.
# For [1, 5, 9, 13], target 7:
# low=0, high=3, mid=1 (arr[1]=5). 5 < 7, so low=2.
# low=2, high=3, mid=2 (arr[2]=9). 9 > 7, so high=1.
# low=2, high=1. low > high, loop ends. Returns -1.
```

-----

## 📌 28. **Count the Number of Occurrences of an Element Using Binary Search**

**🔧 Code:**

```python
def count_occurrences_binary_search(arr, target):
    # Find the first occurrence of the target
    first_occurrence = find_first_occurrence(arr, target)
    if first_occurrence == -1:
        return 0 # Target not found

    # Find the last occurrence of the target
    last_occurrence = find_last_occurrence(arr, target)

    # Count is (last_occurrence - first_occurrence + 1)
    return last_occurrence - first_occurrence + 1

def find_first_occurrence(arr, target):
    low = 0
    high = len(arr) - 1
    result = -1 # Stores the potential first occurrence

    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            result = mid # Found, but try to find an earlier one
            high = mid - 1
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return result

def find_last_occurrence(arr, target):
    low = 0
    high = len(arr) - 1
    result = -1 # Stores the potential last occurrence

    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            result = mid # Found, but try to find a later one
            low = mid + 1
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return result

# ✅ Input:
print(count_occurrences_binary_search([1, 2, 3, 3, 3, 4, 5], 3))
print(count_occurrences_binary_search([1, 2, 4, 5], 3))

# ✅ Output:
# For [1, 2, 3, 3, 3, 4, 5], target 3:
# First occurrence:
# (0,6) mid=3 (arr[3]=3). result=3, high=2.
# (0,2) mid=1 (arr[1]=2). low=2.
# (2,2) mid=2 (arr[2]=3). result=2, high=1.
# (2,1) low>high. Returns 2.
# Last occurrence:
# (0,6) mid=3 (arr[3]=3). result=3, low=4.
# (4,6) mid=5 (arr[5]=4). high=4.
# (4,4) mid=4 (arr[4]=3). result=4, low=5.
# (5,4) low>high. Returns 4.
# Count = 4 - 2 + 1 = 3
#
# For [1, 2, 4, 5], target 3:
# First occurrence returns -1. So count is 0.
```

-----

## 📌 29. **Implement DFS (Depth-First Search) on a Graph Using Adjacency List Representation**

**🔧 Code:**

```python
def dfs(graph, start_node, visited=None):
    if visited is None:
        visited = set() # Keep track of visited nodes

    visited.add(start_node)
    print(start_node, end=" ") # Process the node

    for neighbor in graph.get(start_node, []): # Get neighbors of current node
        if neighbor not in visited:
            dfs(graph, neighbor, visited) # Recursively call DFS for unvisited neighbors

# ✅ Input:
graph_dfs = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}
print("DFS Traversal (starting from A):")
dfs(graph_dfs, 'A')

# ✅ Output:
# DFS Traversal (starting from A):
# A B D E F C
```

-----

## 📌 30. **Implement BFS (Breadth-First Search) and Return the Shortest Path from Source to Destination in an Unweighted Graph**

**🔧 Code:**

```python
from collections import deque

def bfs_shortest_path(graph, start, end):
    queue = deque([(start, [start])]) # Queue stores (node, path_to_node)
    visited = {start} # Keep track of visited nodes

    while queue:
        current_node, path = queue.popleft() # Get current node and its path

        if current_node == end:
            return path # Destination reached, return the path

        for neighbor in graph.get(current_node, []):
            if neighbor not in visited:
                visited.add(neighbor)
                new_path = list(path) # Create new path list
                new_path.append(neighbor)
                queue.append((neighbor, new_path)) # Add neighbor and its path to queue

    return None # No path found

# ✅ Input:
graph_bfs = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E', 'G'],
    'G': []
}
print("\nBFS Shortest Path (A to G):")
print(bfs_shortest_path(graph_bfs, 'A', 'G'))
print("BFS Shortest Path (A to D):")
print(bfs_shortest_path(graph_bfs, 'A', 'D'))
print("BFS Shortest Path (D to C):")
print(bfs_shortest_path(graph_bfs, 'D', 'C'))

# ✅ Output:
# BFS Shortest Path (A to G):
# Path: A -> B -> E -> F -> G
# A to D: A -> B -> D
# D to C: D -> B -> A -> C
```

-----

## 📌 31. **Create a List of Squares of All Even Numbers Between 1 and 20 Using List Comprehension**

**🔧 Code:**

```python
# List comprehension: [expression for item in iterable if condition]
even_squares = [x**2 for x in range(1, 21) if x % 2 == 0]

# ✅ Input:
print(even_squares)

# ✅ Output:
# Iterates numbers from 1 to 20.
# Filters for even numbers (2, 4, 6, ... 20).
# Squares each even number.
# Result: [4, 16, 36, 64, 100, 144, 196, 256, 324, 400]
```

-----

## 📌 32. **Explain the Use of `*args` and `**kwargs` in a Python Function and Implement a Logging Wrapper Function**

**🔧 Code:**

```python
import datetime

def logging_wrapper(func):
    """
    A simple decorator that logs function calls with their arguments and return values.
    Demonstrates *args and **kwargs.
    """
    def wrapper(*args, **kwargs):
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        func_name = func.__name__
        
        # Log arguments
        args_str = ", ".join(map(str, args)) # *args captures positional arguments as a tuple
        kwargs_str = ", ".join([f"{k}={v}" for k, v in kwargs.items()]) # **kwargs captures keyword arguments as a dictionary
        
        print(f"[{timestamp}] Calling function '{func_name}' with args: ({args_str}), kwargs: {{{kwargs_str}}}")
        
        result = func(*args, **kwargs) # Call the original function with unpacked args and kwargs
        
        print(f"[{timestamp}] Function '{func_name}' returned: {result}")
        return result
    return wrapper

@logging_wrapper
def add(a, b):
    return a + b

@logging_wrapper
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

# ✅ Input:
add_result = add(5, 3)
print(f"Add result: {add_result}")

greet_result = greet("Alice", greeting="Hi")
print(f"Greet result: {greet_result}")

greet_default_result = greet("Bob")
print(f"Greet default result: {greet_default_result}")

# ✅ Output:
# [timestamp] Calling function 'add' with args: (5, 3), kwargs: {}
# [timestamp] Function 'add' returned: 8
# Add result: 8
# [timestamp] Calling function 'greet' with args: (Alice), kwargs: {'greeting': 'Hi'}
# [timestamp] Function 'greet' returned: Hi, Alice!
# Greet result: Hi, Alice!
# [timestamp] Calling function 'greet' with args: (Bob), kwargs: {}
# [timestamp] Function 'greet' returned: Hello, Bob!
# Greet default result: Hello, Bob!
```

-----

## 📌 33. **Implement a Simple Decorator That Logs the Execution Time of a Function**

**🔧 Code:**

```python
import time

def timer_decorator(func):
    """
    A decorator that measures and logs the execution time of a function.
    """
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs) # Execute the original function
        end_time = time.time()
        execution_time = end_time - start_time
        print(f"Function '{func.__name__}' executed in {execution_time:.4f} seconds.")
        return result
    return wrapper

@timer_decorator
def long_running_task(n):
    """Simulates a task that takes some time."""
    sum_val = 0
    for i in range(n):
        sum_val += i * i # Perform some operation
    return sum_val

@timer_decorator
def simple_function(a, b):
    time.sleep(0.01) # Simulate a small delay
    return a * b

# ✅ Input:
task_result = long_running_task(1000000)
print(f"Task result: {task_result}")

simple_result = simple_function(10, 5)
print(f"Simple function result: {simple_result}")

# ✅ Output:
# Function 'long_running_task' executed in X.XXXX seconds.
# Task result: 333332833333500000
# Function 'simple_function' executed in Y.YYYY seconds.
# Simple function result: 50
```

-----

## 📌 34. **Create a Generator Function That Yields Even Numbers Indefinitely**

**🔧 Code:**

```python
def even_numbers_generator():
    """
    A generator function that yields even numbers starting from 0, indefinitely.
    """
    num = 0
    while True:
        yield num # Yield the current even number
        num += 2  # Increment by 2 to get the next even number

# ✅ Input:
even_gen = even_numbers_generator()
print(next(even_gen)) # Get the first even number
print(next(even_gen)) # Get the second even number
print(next(even_gen)) # Get the third even number

# Get the next few even numbers using a loop (up to 10 for demonstration)
print("--- Next 5 even numbers ---")
for _ in range(5):
    print(next(even_gen))

# ✅ Output:
# 0
# 2
# 4
# --- Next 5 even numbers ---
# 6
# 8
# 10
# 12
# 14
```

-----

## 📌 35. **Explain and Demonstrate the Difference Between an Iterator and a Generator in Python**

**🔧 Code:**

```python
# --- Iterator Example ---
class MyRangeIterator:
    """
    A simple custom iterator that mimics range() behavior.
    It implements __iter__ and __next__.
    """
    def __init__(self, start, end):
        self.current = start
        self.end = end

    def __iter__(self):
        # __iter__ should return the iterator itself
        return self

    def __next__(self):
        # __next__ returns the next item or raises StopIteration
        if self.current < self.end:
            num = self.current
            self.current += 1
            return num
        else:
            raise StopIteration

print("--- Iterator Demonstration ---")
my_iter = MyRangeIterator(1, 4)
print(next(my_iter))
print(next(my_iter))
print(next(my_iter))
try:
    print(next(my_iter)) # This will raise StopIteration
except StopIteration:
    print("StopIteration caught: Iterator exhausted.")

# Iterators can only be traversed once. To iterate again, a new iterator object is needed.
# for x in my_iter: # This loop won't run as the iterator is exhausted
#    print(x)


# --- Generator Example ---
def my_range_generator(start, end):
    """
    A simple generator function that yields numbers.
    It uses the 'yield' keyword.
    """
    current = start
    while current < end:
        yield current # Pause execution and yield a value
        current += 1  # Resume from here on next call

print("\n--- Generator Demonstration ---")
my_gen = my_range_generator(1, 4)
print(next(my_gen))
print(next(my_gen))
print(next(my_gen))
try:
    print(next(my_gen)) # This will raise StopIteration
except StopIteration:
    print("StopIteration caught: Generator exhausted.")

# Generators are also iterators. They are implicitly iterable and exhaust after one pass.
# However, defining them is more concise.
# To iterate again, you typically call the generator function again to get a new generator object.
print("--- Iterating generator with for loop ---")
for x in my_range_generator(1, 4): # Calling the generator function creates a new generator object
    print(x)

# ✅ Output:
# --- Iterator Demonstration ---
# 1
# 2
# 3
# StopIteration caught: Iterator exhausted.
#
# --- Generator Demonstration ---
# 1
# 2
# 3
# StopIteration caught: Generator exhausted.
# --- Iterating generator with for loop ---
# 1
# 2
# 3
```

-----

## 📌 36. **Write a Lambda Function to Sort a List of Dictionaries by a Nested Key**

**🔧 Code:**

```python
data = [
    {'name': 'Alice', 'details': {'age': 30, 'city': 'New York'}},
    {'name': 'Bob', 'details': {'age': 25, 'city': 'London'}},
    {'name': 'Charlie', 'details': {'age': 35, 'city': 'Paris'}},
    {'name': 'David', 'details': {'age': 25, 'city': 'Tokyo'}} # Same age as Bob
]

# Sort by 'age' (nested key) then by 'name' (outer key) for tie-breaking
# `key` argument expects a function that takes one element from the list
# and returns the value to be used for sorting.
# Here, `lambda x: (x['details']['age'], x['name'])` creates an anonymous function
# that returns a tuple (age, name) for each dictionary. Python sorts tuples
# element by element, achieving the desired multi-level sort.
sorted_data = sorted(data, key=lambda x: (x['details']['age'], x['name']))

# ✅ Input:
print(sorted_data)

# ✅ Output:
# Dictionaries sorted first by age (25, 25, 30, 35), then by name for ties.
# [{'name': 'Bob', 'details': {'age': 25, 'city': 'London'}},
#  {'name': 'David', 'details': {'age': 25, 'city': 'Tokyo'}},
#  {'name': 'Alice', 'details': {'age': 30, 'city': 'New York'}},
#  {'name': 'Charlie', 'details': {'age': 35, 'city': 'Paris'}}]
```

-----

## 📌 37. **Serialize a Python Object Using Pickle and Demonstrate How to Read It Back**

**🔧 Code:**

```python
import pickle

class MyObject:
    """A simple class to demonstrate pickling."""
    def __init__(self, name, value):
        self.name = name
        self.value = value

    def __str__(self):
        return f"MyObject(name='{self.name}', value={self.value})"

# 1. Create an object
obj_to_pickle = MyObject("Example Data", 123)
print(f"Original object: {obj_to_pickle}")

# 2. Serialize the object to a file (pickling)
file_name = "my_object.pkl"
try:
    with open(file_name, 'wb') as file: # 'wb' for write binary mode
        pickle.dump(obj_to_pickle, file)
    print(f"Object successfully pickled to '{file_name}'")
except Exception as e:
    print(f"Error pickling object: {e}")

# 3. Deserialize the object from the file (unpickling)
try:
    with open(file_name, 'rb') as file: # 'rb' for read binary mode
        unpickled_obj = pickle.load(file)
    print(f"Object successfully unpickled: {unpickled_obj}")
except Exception as e:
    print(f"Error unpickling object: {e}")

# Verify that the unpickled object is the same as the original in content
print(f"Are contents equal? {unpickled_obj.name == obj_to_pickle.name and unpickled_obj.value == obj_to_pickle.value}")

# ✅ Output:
# Original object: MyObject(name='Example Data', value=123)
# Object successfully pickled to 'my_object.pkl'
# Object successfully unpickled: MyObject(name='Example Data', value=123)
# Are contents equal? True
```

-----

## 📌 38. **Explain How Python's Garbage Collection Handles Cyclic References**

**🔧 Explanation:**

Python uses a **reference counting** system for garbage collection. Each object has a count of how many references point to it. When an object's reference count drops to zero, it means no variables or other objects are pointing to it, and it can be immediately deallocated.

However, reference counting alone cannot handle **cyclic references**. A cyclic reference occurs when two or more objects refer to each other in a cycle, even if no external references point to them. For example:

```python
class Node:
    def __init__(self, value):
        self.value = value
        self.next = None

a = Node(1)
b = Node(2)
a.next = b # a refers to b
b.next = a # b refers to a (cyclic reference)

# At this point, even if 'a' and 'b' variables go out of scope,
# a.next still points to b, and b.next still points to a.
# Their reference counts would never drop to zero based on simple reference counting.
del a
del b
# The objects (Node(1) and Node(2)) would still technically exist in memory,
# leading to a memory leak if only reference counting was used.
```

To address this, Python has a **cyclic garbage collector** (often called `gc` module). This separate collector runs periodically (or can be triggered manually) and is responsible for finding and collecting groups of objects that are part of a reference cycle and are no longer accessible from outside that cycle.

Here's how it generally works:

1.  **Detection:** The cyclic garbage collector identifies objects that are part of a cycle but are unreachable from the root set (e.g., global variables, active stack frames).
2.  **Collection:** Once identified, these unreachable cyclic references are then deallocated.

**In summary:**

  * **Reference Counting:** Handles most object deallocations immediately when their reference count drops to zero.
  * **Cyclic Garbage Collector:** A supplementary mechanism that identifies and cleans up objects involved in reference cycles that are no longer reachable by the program, preventing memory leaks in such scenarios.

**Example of Cyclic Reference and how `gc` would handle it:**

```python
import gc

class A:
    def __init__(self, name):
        self.name = name
        self.ref_b = None
        print(f"Object A '{self.name}' created.")

    def __del__(self):
        print(f"Object A '{self.name}' destroyed.")

class B:
    def __init__(self, name):
        self.name = name
        self.ref_a = None
        print(f"Object B '{self.name}' created.")

    def __del__(self):
        print(f"Object B '{self.name}' destroyed.")

print("Creating objects with cyclic reference:")
obj_a = A("Alpha")
obj_b = B("Beta")

obj_a.ref_b = obj_b
obj_b.ref_a = obj_a

print("\nDeleting external references to objects:")
del obj_a
del obj_b

print("\nForcing garbage collection (if needed, it runs automatically too):")
# The __del__ methods might not be called immediately due to the cycle.
# Forcing collection can demonstrate it more clearly.
gc.collect()

print("\nEnd of script.")

# ✅ Output (actual output may vary slightly depending on Python version/environment,
# as gc runs automatically):
# Creating objects with cyclic reference:
# Object A 'Alpha' created.
# Object B 'Beta' created.
#
# Deleting external references to objects:
#
# Forcing garbage collection (if needed, it runs automatically too):
# Object A 'Alpha' destroyed.
# Object B 'Beta' destroyed.
#
# End of script.

# Explanation of Output:
# Notice that "Object A 'Alpha' destroyed." and "Object B 'Beta' destroyed."
# are printed only after `gc.collect()` is called (or if the garbage collector
# runs automatically at some point). This demonstrates that even after `del obj_a`
# and `del obj_b` (which reduce their direct reference counts to zero),
# the objects were not immediately destroyed because of the cycle (`obj_a.ref_b`
# still points to `obj_b`, and `obj_b.ref_a` still points to `obj_a`).
# The cyclic garbage collector eventually detects and cleans up these unreachable objects.
```

-----

## 📌 39. **Write Code to Demonstrate the Impact of the Global Interpreter Lock (GIL) Using Multithreading**

**🔧 Code:**

```python
import threading
import time

# Function to perform a CPU-bound task
def cpu_bound_task(n):
    """
    A CPU-bound function that performs a simple calculation.
    """
    count = 0
    for _ in range(n):
        count += 1
    return count

# Demonstrate with a single thread
start_time = time.time()
cpu_bound_task(50_000_000) # Run a moderately large number of iterations
end_time = time.time()
single_thread_time = end_time - start_time
print(f"Single-threaded CPU-bound task took: {single_thread_time:.4f} seconds")

# Demonstrate with multiple threads
NUM_THREADS = 2
ITERATIONS_PER_THREAD = 50_000_000 // NUM_THREADS # Distribute total work

threads = []
start_time_multi = time.time()

for _ in range(NUM_THREADS):
    thread = threading.Thread(target=cpu_bound_task, args=(ITERATIONS_PER_THREAD,))
    threads.append(thread)
    thread.start()

for thread in threads:
    thread.join() # Wait for all threads to complete

end_time_multi = time.time()
multi_thread_time = end_time_multi - start_time_multi
print(f"{NUM_THREADS}-threaded CPU-bound task took: {multi_thread_time:.4f} seconds")

# Explain the GIL's impact
print("\n--- Impact of the Global Interpreter Lock (GIL) ---")
print("Expected behavior with true parallelism (multiple CPU cores) for CPU-bound tasks:")
print("  Multi-threaded time should be significantly less than single-threaded time.")
print("Observed behavior due to GIL:")
print(f"  Single-threaded time: {single_thread_time:.4f} seconds")
print(f"  Multi-threaded time:  {multi_thread_time:.4f} seconds")
if multi_thread_time > single_thread_time * 0.8: # Simple heuristic
    print("Conclusion: The multi-threaded execution for this CPU-bound task is not significantly faster,")
    print("            and may even be slightly slower, which is a classic symptom of the GIL.")
    print("            The GIL prevents multiple Python threads from executing Python bytecode simultaneously,")
    print("            even on multi-core processors.")
else:
    print("Conclusion: The observed difference is within expected variations or the task wasn't purely CPU-bound enough.")

# ✅ Output (example, exact times will vary):
# Single-threaded CPU-bound task took: 2.5000 seconds
# 2-threaded CPU-bound task took: 2.6000 seconds
#
# --- Impact of the Global Interpreter Lock (GIL) ---
# Expected behavior with true parallelism (multiple CPU cores) for CPU-bound tasks:
#   Multi-threaded time should be significantly less than single-threaded time.
# Observed behavior due to GIL:
#   Single-threaded time: 2.5000 seconds
#   Multi-threaded time:  2.6000 seconds
# Conclusion: The multi-threaded execution for this CPU-bound task is not significantly faster,
#             and may even be slightly slower, which is a classic symptom of the GIL.
#             The GIL prevents multiple Python threads from executing Python bytecode simultaneously,
#             even on multi-core processors.
```

**Explanation of GIL's Impact:**

The output clearly demonstrates the effect of the **Global Interpreter Lock (GIL)**. For **CPU-bound tasks** (tasks that spend most of their time doing calculations rather than waiting for I/O), using multiple threads in CPython (the most common Python interpreter) typically does **not lead to a performance gain** and can even introduce overhead, making it slightly slower than a single-threaded approach.

This is because the GIL ensures that **only one thread can execute Python bytecode at a time**, even on multi-core processors. While one thread is running, the others are essentially paused, waiting for their turn to acquire the GIL. This effectively serializes the execution of Python code, preventing true parallel execution of CPU-bound operations across multiple cores.

For **I/O-bound tasks** (tasks that spend most of their time waiting for external operations like network requests or disk I/O), multithreading can still be beneficial. This is because the GIL is released during I/O operations, allowing other threads to run while one thread is waiting.

-----

## 📌 40. **Show the Difference Between Shallow and Deep Copy With Mutable Objects**

**🔧 Code:**

```python
import copy

print("--- Shallow Copy ---")
original_list_shallow = [[1, 2], [3, 4]]
# A shallow copy creates a new compound object, but then
# inserts *references* into it to the objects found in the original.
# This means that changes to mutable nested objects in the copy will affect the original.
shallow_copy_list = list(original_list_shallow) # Using list() for shallow copy

print(f"Original list (shallow): {original_list_shallow}")
print(f"Shallow copy list: {shallow_copy_list}")
print(f"Are they the same object? {original_list_shallow is shallow_copy_list}") # False (new list object)
print(f"Do they contain the same sub-objects? {original_list_shallow[0] is shallow_copy_list[0]}") # True (same sub-list object)

# Modify a nested mutable object in the shallow copy
shallow_copy_list[0].append(5) # Modifies the first sub-list
print(f"\nAfter modifying nested sub-list in shallow copy:")
print(f"Original list (shallow): {original_list_shallow}")
print(f"Shallow copy list: {shallow_copy_list}")
print("Observation: Both lists reflect the change to the nested list because they share the same nested list object.")

# Modify a top-level element in the shallow copy
shallow_copy_list.append([6, 7]) # Adds a new sub-list to the shallow copy
print(f"\nAfter adding top-level element to shallow copy:")
print(f"Original list (shallow): {original_list_shallow}")
print(f"Shallow copy list: {shallow_copy_list}")
print("Observation: Adding a top-level element only affects the copy, not the original.")


print("\n--- Deep Copy ---")
original_list_deep = [[1, 2], [3, 4]]
# A deep copy creates a new compound object and then,
# recursively, inserts *copies* into it of the objects found in the original.
# This means that changes to mutable nested objects in the copy will NOT affect the original.
deep_copy_list = copy.deepcopy(original_list_deep) # Using copy.deepcopy()

print(f"Original list (deep): {original_list_deep}")
print(f"Deep copy list: {deep_copy_list}")
print(f"Are they the same object? {original_list_deep is deep_copy_list}") # False (new list object)
print(f"Do they contain the same sub-objects? {original_list_deep[0] is deep_copy_list[0]}") # False (new sub-list object)

# Modify a nested mutable object in the deep copy
deep_copy_list[0].append(5) # Modifies the first sub-list in the deep copy
print(f"\nAfter modifying nested sub-list in deep copy:")
print(f"Original list (deep): {original_list_deep}")
print(f"Deep copy list: {deep_copy_list}")
print("Observation: Only the deep copy reflects the change; the original remains unchanged.")

# ✅ Output:
# --- Shallow Copy ---
# Original list (shallow): [[1, 2], [3, 4]]
# Shallow copy list: [[1, 2], [3, 4]]
# Are they the same object? False
# Do they contain the same sub-objects? True
#
# After modifying nested sub-list in shallow copy:
# Original list (shallow): [[1, 2, 5], [3, 4]]
# Shallow copy list: [[1, 2, 5], [3, 4]]
# Observation: Both lists reflect the change to the nested list because they share the same nested list object.
#
# After adding top-level element to shallow copy:
# Original list (shallow): [[1, 2, 5], [3, 4]]
# Shallow copy list: [[1, 2, 5], [3, 4], [6, 7]]
# Observation: Adding a top-level element only affects the copy, not the original.
#
# --- Deep Copy ---
# Original list (deep): [[1, 2], [3, 4]]
# Deep copy list: [[1, 2], [3, 4]]
# Are they the same object? False
# Do they contain the same sub-objects? False
#
# After modifying nested sub-list in deep copy:
# Original list (deep): [[1, 2], [3, 4]]
# Deep copy list: [[1, 2, 5], [3, 4]]
# Observation: Only the deep copy reflects the change; the original remains unchanged.
```

**Explanation:**

  * **Shallow Copy:**

      * Creates a new compound object (e.g., a new list).
      * It then populates this new object with **references** to the *same objects* that are contained in the original.
      * If the original object contains mutable sub-objects (like nested lists or dictionaries), modifying these sub-objects through the shallow copy will also affect the original object because they refer to the identical sub-objects in memory.
      * Changes to the top-level structure of the shallow copy (e.g., appending a new element to the shallow copied list) will *not* affect the original, as the top-level objects are distinct.

  * **Deep Copy:**

      * Creates a new compound object.
      * Then, recursively creates **copies** of *all* objects found in the original.
      * This means that the deep copy is completely independent of the original object, including any nested mutable objects.
      * Changes made to the deep copy (whether at the top-level or within nested mutable objects) will *not* affect the original object.

**When to use which:**

  * Use **shallow copy** when you have a simple collection of immutable objects, or when you specifically want changes to nested mutable objects to be reflected in both the original and the copy.
  * Use **deep copy** when you need a completely independent copy of an object, especially if it contains nested mutable objects, and you want to ensure that modifications to the copy do not impact the original. Deep copy can be more computationally expensive due to the recursive copying.

-----

## 📌 41. **Write a Function to Check if Two Strings Are Anagrams**

**🔧 Code:**

```python
def are_anagrams(s1, s2):
    # Anagrams must have the same length
    if len(s1) != len(s2):
        return False

    # Count character frequencies for both strings
    freq1 = {}
    for char in s1:
        freq1[char] = freq1.get(char, 0) + 1

    freq2 = {}
    for char in s2:
        freq2[char] = freq2.get(char, 0) + 1

    # Compare the frequency dictionaries
    return freq1 == freq2

# ✅ Input:
print(are_anagrams("listen", "silent")) # True
print(are_anagrams("hello", "world"))  # False
print(are_anagrams("aabb", "bbaa"))   # True
print(are_anagrams("rat", "car"))     # False

# ✅ Output:
# For "listen", "silent":
# freq1 = {'l': 1, 'i': 1, 's': 1, 't': 1, 'e': 1, 'n': 1}
# freq2 = {'s': 1, 'i': 1, 'l': 1, 'e': 1, 'n': 1, 't': 1}
# freq1 == freq2 → True
#
# For "hello", "world":
# Lengths are different (5 != 5, but characters differ)
# freq1 = {'h':1, 'e':1, 'l':2, 'o':1}
# freq2 = {'w':1, 'o':1, 'r':1, 'l':1, 'd':1}
# freq1 != freq2 → False
```

-----

## 📌 42. **Determine if a Given Number Is an Armstrong Number**

**🔧 Code:**

```python
def is_armstrong_number(n):
    if not isinstance(n, int) or n < 0:
        return False # Armstrong numbers are non-negative integers

    num_str = str(n)
    num_digits = len(num_str)
    
    armstrong_sum = 0
    for digit_char in num_str:
        digit = int(digit_char)
        armstrong_sum += digit ** num_digits # Sum of each digit raised to the power of number of digits

    return armstrong_sum == n

# ✅ Input:
print(is_armstrong_number(153)) # 1^3 + 5^3 + 3^3 = 1 + 125 + 27 = 153 → True
print(is_armstrong_number(9))   # 9^1 = 9 → True (single digit numbers are Armstrong)
print(is_armstrong_number(370)) # 3^3 + 7^3 + 0^3 = 27 + 343 + 0 = 370 → True
print(is_armstrong_number(123)) # 1^3 + 2^3 + 3^3 = 1 + 8 + 27 = 36 != 123 → False

# ✅ Output:
# is_armstrong_number(153) → True
# is_armstrong_number(9) → True
# is_armstrong_number(370) → True
# is_armstrong_number(123) → False
```

-----

## 📌 43. **Check Whether a Year Is a Leap Year Without Using Built-in Libraries**

**🔧 Code:**

```python
def is_leap_year(year):
    # Rule 1: A year is a leap year if it is divisible by 4
    if year % 4 == 0:
        # Rule 2: But if it is divisible by 100, it is NOT a leap year
        if year % 100 == 0:
            # Rule 3: Unless it is also divisible by 400
            if year % 400 == 0:
                return True # Divisible by 400, so it's a leap year
            else:
                return False # Divisible by 100 but not 400, so not a leap year
        else:
            return True # Divisible by 4 but not 100, so it's a leap year
    else:
        return False # Not divisible by 4, so not a leap year

# ✅ Input:
print(is_leap_year(2000)) # Divisible by 400 → True
print(is_leap_year(1900)) # Divisible by 100 but not 400 → False
print(is_leap_year(2024)) # Divisible by 4 but not 100 → True
print(is_leap_year(2023)) # Not divisible by 4 → False

# ✅ Output:
# 2000 → True
# 1900 → False
# 2024 → True
# 2023 → False
```

-----

## 📌 44. **Merge Two Already Sorted Lists into One Sorted List Without Using Extra Space**

**Note:** "Without using extra space" for merging two lists in Python is typically interpreted as *in-place* merging or merging with *O(1) auxiliary space*. However, Python lists are dynamic arrays. Achieving a true O(1) auxiliary space merge for arbitrary sorted arrays that modifies the input arrays can be complex and might involve shifting elements extensively, leading to poor time complexity. A common interview interpretation for "without extra space" might allow modifying one of the input arrays.

A more practical approach for "without extra space" in Python, if we *must* modify the input lists and want to achieve an efficient merge, is to merge into one of the existing lists (e.g., `list1`) if it has enough pre-allocated space (which isn't how Python lists usually work directly).

For typical Pythonic answers, if modifying inputs is allowed, you might merge into a *new* list, which uses O(N+M) space. If strict in-place is required, it often implies a different underlying data structure (like linked lists or fixed-size arrays in lower-level languages) or a less efficient algorithm for Python lists.

Given the constraint "without using extra space," and knowing Python's list behavior, the most direct way to *simulate* an in-place merge (where the result resides in one of the input arrays) would be to merge into a potentially larger first list, if it was indeed pre-sized. However, since Python lists grow dynamically, any new list construction implies O(N+M) space.

A common *interview trick* when they say "without extra space" for arrays, sometimes means you are modifying one of the arrays in place, assuming it has sufficient "empty" slots at the end. Since Python lists don't natively expose "empty slots" in that sense, directly creating a `result` list is the most Pythonic and efficient way to *merge* sorted lists, though it uses `O(N+M)` space.

If the prompt strictly means `O(1)` auxiliary space, then Python's `list.sort()` after `list.extend()` would be the closest, but `list.sort()` itself might not be O(1) space.

Let's provide the common approach where we *append* and then sort, or a manual merge into a new list. The manual merge is usually what's expected for "merging sorted lists," even if it creates a new list.

For the purpose of "without using extra space" to the *spirit* of the problem (modifying an existing structure), let's assume one list has enough capacity or we're allowed to use `list.extend` and then sort (which modifies the original list in-place after extension). This is the most practical "no extra space for the *result array*" interpretation for Python lists.

**Revised interpretation for "without extra space":** We will assume we can modify one of the input lists and extend it, then sort it. This isn't a typical merge algorithm, but aligns with "no extra explicit result list."

```python
def merge_sorted_lists_in_place(list1, list2):
    """
    Merges list2 into list1 and sorts list1.
    This modifies list1 in-place. Note: This is NOT a classic two-pointer merge
    that maintains sorted order during concatenation in O(N+M) time.
    Instead, it uses Python's extend and sort, which are optimized.
    The 'without extra space' constraint in Python for arbitrary lists
    is tricky; list.extend() and list.sort() work in-place for lists,
    but list.sort() might use some temporary space internally (though often O(log N) or O(N)).
    """
    list1.extend(list2) # Appends all elements from list2 to list1
    list1.sort()        # Sorts list1 in-place

# ✅ Input:
list_a = [1, 3, 5]
list_b = [2, 4, 6]
merge_sorted_lists_in_place(list_a, list_b)
print(list_a) # list_a should now contain the merged and sorted elements

list_c = [10, 20]
list_d = [1, 5, 15, 25]
merge_sorted_lists_in_place(list_c, list_d)
print(list_c)

# ✅ Output:
# For list_a = [1, 3, 5], list_b = [2, 4, 6]:
# list_a.extend(list_b) → [1, 3, 5, 2, 4, 6]
# list_a.sort() → [1, 2, 3, 4, 5, 6]
#
# For list_c = [10, 20], list_d = [1, 5, 15, 25]:
# list_c.extend(list_d) → [10, 20, 1, 5, 15, 25]
# list_c.sort() → [1, 5, 10, 15, 20, 25]
```

**Alternative (Classic Merge, but Uses O(N+M) space):**

If "without extra space" means "don't create an explicit `result` list of size `N+M` in the loop", but creating a *new list* is still fine for the final result (this is often the interpretation in interviews for Python lists where modifying inputs in-place to fit a combined size isn't feasible).

```python
def merge_two_sorted_lists_classic(list1, list2):
    """
    Classic merge of two sorted lists.
    This creates a new list, thus uses O(N+M) auxiliary space.
    """
    result = []
    i, j = 0, 0

    while i < len(list1) and j < len(list2):
        if list1[i] <= list2[j]:
            result.append(list1[i])
            i += 1
        else:
            result.append(list2[j])
            j += 1

    # Append any remaining elements
    result.extend(list1[i:])
    result.extend(list2[j:])
    
    return result

# ✅ Input:
print(merge_two_sorted_lists_classic([1, 3, 5], [2, 4, 6]))
print(merge_two_sorted_lists_classic([10, 20], [1, 5, 15, 25]))

# ✅ Output:
# [1, 2, 3, 4, 5, 6]
# [1, 5, 10, 15, 20, 25]
```

Given the ambiguity of "without extra space" for Python lists, I've provided the `extend().sort()` method which modifies one list in-place (often considered "less extra space" if the final result replaces an input list) and the `classic_merge` which is the standard algorithm but uses `O(N+M)` space for the new result list. The `extend().sort()` is probably the closest to the literal interpretation if the input lists are Python's dynamic arrays.

-----

## 📌 45. **Count the Number of Words in a Paragraph-like Sentence**

**🔧 Code:**

```python
def count_words_in_paragraph(paragraph):
    # Basic tokenization: split by spaces.
    # filter(None, ...) removes empty strings that result from multiple spaces.
    words = list(filter(None, paragraph.split()))
    return len(words)

# ✅ Input:
print(count_words_in_paragraph("This is a sample paragraph."))
print(count_words_in_paragraph("  Another   paragraph with   extra spaces.  "))
print(count_words_in_paragraph("")) # Empty string
print(count_words_in_paragraph("OneWord")) # Single word

# ✅ Output:
# "This is a sample paragraph." → ['This', 'is', 'a', 'sample', 'paragraph.'] → 5
# "  Another   paragraph with   extra spaces.  " → ['Another', 'paragraph', 'with', 'extra', 'spaces.'] → 5
# "" → [] → 0
# "OneWord" → ['OneWord'] → 1
```

-----

## 46\. **Write a function to calculate the digital root of a number.**

**🔧 Code:**

```python
def digital_root(n):
    # Digital root is calculated by repeatedly summing its digits until a single-digit number is reached.
    # It can also be found using the formula: dr(n) = 1 + (n - 1) % 9 for n > 0.
    # For n = 0, the digital root is 0.

    if n < 0:
        return "Digital root not defined for negative numbers"
    if n == 0:
        return 0

    return 1 + (n - 1) % 9

# Recursive (simpler to understand the process):
def digital_root_recursive(n):
    if n < 0:
        return "Digital root not defined for negative numbers"
    if n < 10: # Base case: single-digit number
        return n
    
    sum_digits = 0
    temp_n = n
    while temp_n > 0:
        sum_digits += temp_n % 10 # Get last digit
        temp_n //= 10             # Remove last digit
        
    return digital_root_recursive(sum_digits) # Recursively call with the sum

# ✅ Input:
print(f"Digital root of 456 (formula): {digital_root(456)}")
print(f"Digital root of 456 (recursive): {digital_root_recursive(456)}")
print(f"Digital root of 19 (formula): {digital_root(19)}")
print(f"Digital root of 19 (recursive): {digital_root_recursive(19)}")
print(f"Digital root of 0 (formula): {digital_root(0)}")
print(f"Digital root of 0 (recursive): {digital_root_recursive(0)}")
print(f"Digital root of -10: {digital_root(-10)}")

# ✅ Output:
# Digital root of 456 (formula): 6 (1 + (456-1)%9 = 1 + 455%9 = 1 + 5 = 6)
# Digital root of 456 (recursive): 6 (4+5+6=15, 1+5=6)
# Digital root of 19 (formula): 1 (1 + (19-1)%9 = 1 + 18%9 = 1 + 0 = 1)
# Digital root of 19 (recursive): 1 (1+9=10, 1+0=1)
# Digital root of 0 (formula): 0
# Digital root of 0 (recursive): 0
# Digital root of -10: Digital root not defined for negative numbers
```

-----

## 47\. **Create a program to simulate a basic calculator using functions and input parsing.**

**🔧 Code:**

```python
def add(x, y):
    return x + y

def subtract(x, y):
    return x - y

def multiply(x, y):
    return x * y

def divide(x, y):
    if y == 0:
        return "Error: Cannot divide by zero!"
    return x / y

def basic_calculator():
    print("Welcome to Simple Calculator!")
    print("Select operation:")
    print("1. Add")
    print("2. Subtract")
    print("3. Multiply")
    print("4. Divide")
    print("5. Exit")

    while True:
        choice = input("Enter choice(1/2/3/4/5): ")

        if choice == '5':
            print("Exiting calculator. Goodbye!")
            break

        if choice in ('1', '2', '3', '4'):
            try:
                num1 = float(input("Enter first number: "))
                num2 = float(input("Enter second number: "))
            except ValueError:
                print("Invalid input. Please enter numbers only.")
                continue

            if choice == '1':
                print(f"{num1} + {num2} = {add(num1, num2)}")
            elif choice == '2':
                print(f"{num1} - {num2} = {subtract(num1, num2)}")
            elif choice == '3':
                print(f"{num1} * {num2} = {multiply(num1, num2)}")
            elif choice == '4':
                result = divide(num1, num2)
                print(f"{num1} / {num2} = {result}")
        else:
            print("Invalid input. Please enter a valid choice (1-5).")

# ✅ Input (simulated interaction):
# basic_calculator()
# Enter choice(1/2/3/4/5): 1
# Enter first number: 10
# Enter second number: 5
#
# Enter choice(1/2/3/4/5): 4
# Enter first number: 8
# Enter second number: 0
#
# Enter choice(1/2/3/4/5): invalid
#
# Enter choice(1/2/3/4/5): 5

# ✅ Output (from simulated interaction):
# Welcome to Simple Calculator!
# Select operation:
# 1. Add
# 2. Subtract
# 3. Multiply
# 4. Divide
# 5. Exit
# Enter choice(1/2/3/4/5): 1
# Enter first number: 10
# Enter second number: 5
# 10.0 + 5.0 = 15.0
# Enter choice(1/2/3/4/5): 4
# Enter first number: 8
# Enter second number: 0
# 8.0 / 0.0 = Error: Cannot divide by zero!
# Enter choice(1/2/3/4/5): invalid
# Invalid input. Please enter a valid choice (1-5).
# Enter choice(1/2/3/4/5): 5
# Exiting calculator. Goodbye!
```

-----

## 48\. **Given a list of meeting times, determine if a person can attend all meetings without overlap.**

**🔧 Code:**

```python
def can_attend_all_meetings(meetings):
    """
    Determines if a person can attend all meetings without any overlap.
    Meetings are given as a list of tuples or lists, e.g., [(start1, end1), (start2, end2)].
    """
    if not meetings:
        return True # No meetings, so no overlap

    # Sort meetings by their start times
    # This is crucial because it allows us to just check the end time of the current meeting
    # against the start time of the next meeting.
    meetings.sort(key=lambda x: x[0])

    # Iterate through the sorted meetings and check for overlaps
    for i in range(len(meetings) - 1):
        current_meeting_end = meetings[i][1]
        next_meeting_start = meetings[i+1][0]

        # Overlap occurs if the current meeting ends AFTER the next meeting starts
        # (or exactly at the same time if exclusive intervals are assumed, but
        # typically, [1,2] and [2,3] are considered non-overlapping)
        if current_meeting_end > next_meeting_start:
            return False # Overlap detected

    return True # No overlaps found

# ✅ Input:
print(f"Can attend [(0, 30), (5, 10), (15, 20)]? {can_attend_all_meetings([(0, 30), (5, 10), (15, 20)])}")
print(f"Can attend [(7, 10), (2, 4)]? {can_attend_all_meetings([(7, 10), (2, 4)])}")
print(f"Can attend [(1, 5), (5, 10), (10, 15)]? {can_attend_all_meetings([(1, 5), (5, 10), (10, 15)])}")
print(f"Can attend []? {can_attend_all_meetings([])}")
print(f"Can attend [(1, 2)]? {can_attend_all_meetings([(1, 2)])}")

# ✅ Output:
# For [(0, 30), (5, 10), (15, 20)]:
# Sorted: [(0, 30), (5, 10), (15, 20)] (original order)
# Check 1: (0,30) vs (5,10) -> 30 > 5. Overlap. Returns False.
#
# For [(7, 10), (2, 4)]:
# Sorted: [(2, 4), (7, 10)]
# Check 1: (2,4) vs (7,10) -> 4 > 7 is False. No overlap. Returns True.
#
# For [(1, 5), (5, 10), (10, 15)]:
# Sorted: [(1, 5), (5, 10), (10, 15)]
# Check 1: (1,5) vs (5,10) -> 5 > 5 is False. No overlap.
# Check 2: (5,10) vs (10,15) -> 10 > 10 is False. No overlap. Returns True.
#
# For []: True
# For [(1, 2)]: True
```

-----

## 49\. **Define a `BankAccount` class with methods for deposit, withdrawal, and balance inquiry.**

**🔧 Code:**

```python
class BankAccount:
    def __init__(self, account_holder, initial_balance=0):
        self.account_holder = account_holder
        # Balance is a private-like attribute (convention, not strict enforcement)
        if initial_balance >= 0:
            self.__balance = initial_balance
        else:
            self.__balance = 0
            print("Initial balance cannot be negative. Setting to 0.")

    def deposit(self, amount):
        if amount > 0:
            self.__balance += amount
            print(f"Deposited ${amount:.2f}. New balance: ${self.__balance:.2f}")
        else:
            print("Deposit amount must be positive.")

    def withdraw(self, amount):
        if amount <= 0:
            print("Withdrawal amount must be positive.")
        elif amount > self.__balance:
            print("Insufficient funds.")
        else:
            self.__balance -= amount
            print(f"Withdrew ${amount:.2f}. New balance: ${self.__balance:.2f}")

    def get_balance(self):
        return self.__balance

    def __str__(self):
        return f"Account Holder: {self.account_holder}, Balance: ${self.__balance:.2f}"

# ✅ Input:
account1 = BankAccount("Alice Smith", 1000)
print(account1)
account1.deposit(200)
account1.withdraw(150)
print(f"Current balance for {account1.account_holder}: ${account1.get_balance():.2f}")
account1.withdraw(1500) # Insufficient funds
account1.deposit(-50)   # Invalid deposit
account2 = BankAccount("Bob Johnson", -50) # Invalid initial balance

# ✅ Output:
# Account Holder: Alice Smith, Balance: $1000.00
# Deposited $200.00. New balance: $1200.00
# Withdrew $150.00. New balance: $1050.00
# Current balance for Alice Smith: $1050.00
# Insufficient funds.
# Deposit amount must be positive.
# Initial balance cannot be negative. Setting to 0.
```

-----

## 50\. **Implement a base class `Employee` and derive a class `Manager` that includes a list of employees managed.**

**🔧 Code:**

```python
class Employee:
    def __init__(self, employee_id, name, salary):
        self.employee_id = employee_id
        self.name = name
        self.salary = salary

    def get_details(self):
        return f"ID: {self.employee_id}, Name: {self.name}, Salary: ${self.salary:.2f}"

    def give_raise(self, percentage):
        if percentage > 0:
            raise_amount = self.salary * (percentage / 100)
            self.salary += raise_amount
            print(f"{self.name}'s new salary: ${self.salary:.2f}")
        else:
            print("Raise percentage must be positive.")

class Manager(Employee):
    def __init__(self, employee_id, name, salary, department):
        super().__init__(employee_id, name, salary) # Call parent constructor
        self.department = department
        self.managed_employees = [] # List to hold Employee objects

    def add_managed_employee(self, employee):
        if isinstance(employee, Employee) and employee not in self.managed_employees:
            self.managed_employees.append(employee)
            print(f"{employee.name} added to {self.name}'s team.")
        else:
            print(f"Could not add {employee.name if isinstance(employee, Employee) else 'invalid employee'} to team.")

    def remove_managed_employee(self, employee):
        if employee in self.managed_employees:
            self.managed_employees.remove(employee)
            print(f"{employee.name} removed from {self.name}'s team.")
        else:
            print(f"{employee.name} is not managed by {self.name}.")

    def get_managed_employees_details(self):
        if not self.managed_employees:
            return f"{self.name} manages no employees."
        details = [f"- {emp.name} (ID: {emp.employee_id})" for emp in self.managed_employees]
        return f"{self.name} manages:\n" + "\n".join(details)

    # Override get_details to include manager-specific information
    def get_details(self):
        base_details = super().get_details()
        return f"{base_details}, Department: {self.department}"

# ✅ Input:
emp1 = Employee("E001", "John Doe", 50000)
emp2 = Employee("E002", "Jane Smith", 55000)
emp3 = Employee("E003", "Peter Jones", 60000)

manager1 = Manager("M001", "Alice Brown", 80000, "Sales")

print(manager1.get_details())
manager1.add_managed_employee(emp1)
manager1.add_managed_employee(emp2)
manager1.add_managed_employee(emp3)
print("\n" + manager1.get_managed_employees_details())

manager1.remove_managed_employee(emp2)
print("\n" + manager1.get_managed_employees_details())

emp1.give_raise(5)
manager1.give_raise(10)

# ✅ Output:
# ID: M001, Name: Alice Brown, Salary: $80000.00, Department: Sales
# John Doe added to Alice Brown's team.
# Jane Smith added to Alice Brown's team.
# Peter Jones added to Alice Brown's team.
#
# Alice Brown manages:
# - John Doe (ID: E001)
# - Jane Smith (ID: E002)
# - Peter Jones (ID: E003)
# Jane Smith removed from Alice Brown's team.
#
# Alice Brown manages:
# - John Doe (ID: E001)
# - Peter Jones (ID: E003)
# John Doe's new salary: $52500.00
# Alice Brown's new salary: $88000.00
```

-----

## 51\. **Demonstrate polymorphism using a method called `speak()` in two classes: `Dog` and `Cat`.**

**🔧 Code:**

```python
class Dog:
    def __init__(self, name):
        self.name = name

    def speak(self):
        return f"{self.name} says Woof!"

class Cat:
    def __init__(self, name):
        self.name = name

    def speak(self):
        return f"{self.name} says Meow!"

# Function demonstrating polymorphism
def make_animal_speak(animal):
    """
    This function can accept any object that has a 'speak' method.
    The specific 'speak' implementation used depends on the object's type.
    """
    print(animal.speak())

# ✅ Input:
my_dog = Dog("Buddy")
my_cat = Cat("Whiskers")

make_animal_speak(my_dog)
make_animal_speak(my_cat)

# We can also put them in a list and iterate
animals = [Dog("Max"), Cat("Bella"), Dog("Lucy")]
print("\n--- Animals in a list ---")
for animal in animals:
    make_animal_speak(animal)

# ✅ Output:
# Buddy says Woof!
# Whiskers says Meow!
#
# --- Animals in a list ---
# Max says Woof!
# Bella says Meow!
# Lucy says Woof!
```

-----

## 52\. **Write an example of encapsulation by creating a class with private variables and public getters/setters.**

**🔧 Code:**

```python
class Product:
    def __init__(self, product_id, name, price):
        self.__product_id = product_id  # Private variable (conventionally with __ prefix)
        self.__name = name              # Private variable
        self.__price = self.__validate_price(price) # Use setter-like validation in init

    def __validate_price(self, price):
        """Helper for price validation."""
        if price >= 0:
            return price
        else:
            print("Price cannot be negative. Setting to 0.")
            return 0

    # Public Getter for product_id (read-only for ID)
    def get_product_id(self):
        return self.__product_id

    # Public Getter for name
    def get_name(self):
        return self.__name

    # Public Setter for name
    def set_name(self, new_name):
        if new_name and isinstance(new_name, str):
            self.__name = new_name
            print(f"Product name updated to: {new_name}")
        else:
            print("Invalid name. Name must be a non-empty string.")

    # Public Getter for price
    def get_price(self):
        return self.__price

    # Public Setter for price (with validation)
    def set_price(self, new_price):
        validated_price = self.__validate_price(new_price)
        if validated_price != self.__price: # Only update if different and valid
            self.__price = validated_price
            print(f"Product price updated to: ${new_price:.2f}")
        else:
            print(f"Price not updated (either invalid or same as current). Current price: ${self.__price:.2f}")

    def get_product_info(self):
        return f"Product ID: {self.__product_id}, Name: {self.__name}, Price: ${self.__price:.2f}"

# ✅ Input:
product1 = Product("P001", "Laptop", 1200.50)
print(product1.get_product_info())

# Attempt to access private variables directly (will cause an AttributeError or name mangling)
# print(product1.__price) # This will generally fail with AttributeError

# Use getters
print(f"Product ID: {product1.get_product_id()}")
print(f"Product Name: {product1.get_name()}")
print(f"Product Price: ${product1.get_price():.2f}")

# Use setters
product1.set_name("Gaming Laptop")
product1.set_price(1350.00)
product1.set_price(-100) # Invalid price
product1.set_name("") # Invalid name

print(product1.get_product_info())

# ✅ Output:
# Product ID: P001, Name: Laptop, Price: $1200.50
# Product ID: P001
# Product Name: Laptop
# Product Price: $1200.50
# Product name updated to: Gaming Laptop
# Product price updated to: $1350.00
# Price cannot be negative. Setting to 0.
# Price not updated (either invalid or same as current). Current price: $1350.00
# Invalid name. Name must be a non-empty string.
# Product ID: P001, Name: Gaming Laptop, Price: $1350.00
```

-----

## 53\. **Implement a class method and a static method in a `Product` class.**

**🔧 Code:**

```python
class Product:
    # Class variable to keep track of total products created
    total_products = 0
    
    def __init__(self, name, price):
        self.name = name
        self.price = price
        Product.total_products += 1 # Increment class variable on instance creation

    # Instance method: operates on an instance of the class (self)
    def get_product_info(self):
        return f"Product: {self.name}, Price: ${self.price:.2f}"

    @classmethod
    def create_from_string(cls, product_string):
        """
        Class method: takes 'cls' (the class itself) as the first argument.
        Can access/modify class-level attributes (like total_products)
        and can be used as alternative constructors.
        Here, it creates a Product instance from a formatted string.
        """
        parts = product_string.split(',')
        if len(parts) == 2:
            name = parts[0].strip()
            price = float(parts[1].strip())
            return cls(name, price) # Use 'cls' to create an instance of the class
        else:
            raise ValueError("Invalid product string format. Expected 'name, price'")

    @staticmethod
    def get_currency_symbol(country_code):
        """
        Static method: does NOT take 'self' or 'cls' as the first argument.
        It's like a regular function defined inside the class.
        It doesn't depend on instance-specific data or class-specific data,
        but logically belongs to the class's namespace.
        """
        if country_code.upper() == "US":
            return "$"
        elif country_code.upper() == "EU":
            return "€"
        else:
            return ""

# ✅ Input:
# Create instances using the regular constructor
prod1 = Product("Laptop", 1200)
prod2 = Product("Mouse", 25)

# Use the instance method
print(prod1.get_product_info())

# Use the class method as an alternative constructor
prod3 = Product.create_from_string("Keyboard, 75.50")
print(prod3.get_product_info())

# Access the class variable directly
print(f"Total products created: {Product.total_products}")

# Use the static method (can be called via class or instance)
print(f"Currency for US: {Product.get_currency_symbol('US')}")
print(f"Currency for EU: {prod1.get_currency_symbol('EU')}") # Can also call via instance

# ✅ Output:
# Product: Laptop, Price: $1200.00
# Product: Keyboard, Price: $75.50
# Total products created: 3
# Currency for US: $
# Currency for EU: €
```

-----

## 54\. **Create a class that overloads the `+` operator to merge two shopping carts.**

**🔧 Code:**

```python
class ShoppingCart:
    def __init__(self, items=None):
        self.items = items if items is not None else {} # Dictionary: item_name -> quantity

    def add_item(self, item_name, quantity=1):
        if quantity > 0:
            self.items[item_name] = self.items.get(item_name, 0) + quantity
            print(f"Added {quantity} x {item_name} to cart.")
        else:
            print("Quantity must be positive.")

    def __add__(self, other):
        """
        Overloads the '+' operator. When you do cart1 + cart2,
        this method is called on cart1 with cart2 as 'other'.
        It creates a new ShoppingCart that combines items from both.
        """
        if not isinstance(other, ShoppingCart):
            raise TypeError("Can only add ShoppingCart objects together.")

        merged_items = self.items.copy() # Start with items from the first cart

        for item, quantity in other.items.items():
            merged_items[item] = merged_items.get(item, 0) + quantity # Add quantities for common items

        return ShoppingCart(merged_items) # Return a new ShoppingCart instance

    def __str__(self):
        if not self.items:
            return "Shopping Cart: Empty"
        item_list = [f"{item} ({qty})" for item, qty in self.items.items()]
        return "Shopping Cart: " + ", ".join(item_list)

# ✅ Input:
cart1 = ShoppingCart()
cart1.add_item("Apple", 2)
cart1.add_item("Banana", 3)
print(cart1)

cart2 = ShoppingCart()
cart2.add_item("Banana", 1)
cart2.add_item("Orange", 4)
print(cart2)

# Use the overloaded '+' operator to merge carts
merged_cart = cart1 + cart2
print("\nMerged Cart:")
print(merged_cart)

# Demonstrate addition with an empty cart
empty_cart = ShoppingCart()
cart3 = merged_cart + empty_cart
print("\nCart after adding empty cart:")
print(cart3)

# Demonstrate non-ShoppingCart addition (will raise TypeError)
try:
    cart_error = cart1 + [1, 2, 3]
except TypeError as e:
    print(f"\nCaught expected error: {e}")

# ✅ Output:
# Added 2 x Apple to cart.
# Added 3 x Banana to cart.
# Shopping Cart: Apple (2), Banana (3)
# Added 1 x Banana to cart.
# Added 4 x Orange to cart.
# Shopping Cart: Banana (1), Orange (4)
#
# Merged Cart:
# Shopping Cart: Apple (2), Banana (4), Orange (4)
#
# Cart after adding empty cart:
# Shopping Cart: Apple (2), Banana (4), Orange (4)
#
# Caught expected error: Can only add ShoppingCart objects together.
```

-----

## 1\. **Find the Longest Word**

**Problem:** Write code to find the word with the maximum length in the `words` list.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "grapefruit", "orange"]

longest_word = ""
max_length = 0

for word in words:
    if len(word) > max_length:
        max_length = len(word)
        longest_word = word

print(f"The longest word is: '{longest_word}' with length {max_length}")

# ✅ Output:
# Iteration 1: "apple", len=5. max_length=5, longest_word="apple"
# Iteration 2: "banana", len=6. max_length=6, longest_word="banana"
# Iteration 3: "kiwi", len=4. (no change)
# Iteration 4: "grapefruit", len=10. max_length=10, longest_word="grapefruit"
# Iteration 5: "orange", len=6. (no change)
# The longest word is: 'grapefruit' with length 10
```

-----

## 2\. **Reverse the List**

**Problem:** Write a loop that reverses the `words` list without using `reverse()` or slicing.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "grapefruit", "orange"]

left = 0
right = len(words) - 1

while left < right:
    # Swap elements from both ends
    words[left], words[right] = words[right], words[left]
    left += 1
    right -= 1

print(f"Reversed list: {words}")

# ✅ Output:
# Initial: ["apple", "banana", "kiwi", "grapefruit", "orange"]
# Swap "apple" and "orange": ["orange", "banana", "kiwi", "grapefruit", "apple"]
# Swap "banana" and "grapefruit": ["orange", "grapefruit", "kiwi", "banana", "apple"]
# Pointers cross.
# Reversed list: ['orange', 'grapefruit', 'kiwi', 'banana', 'apple']
```

-----

## 3\. **Word Frequency**

**Problem:** Count the frequency of each word in the `words` list using a dictionary.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "apple", "grapefruit", "banana", "orange"]

word_frequency = {}

for word in words:
    word_frequency[word] = word_frequency.get(word, 0) + 1

print(f"Word frequencies: {word_frequency}")

# ✅ Output:
# 'apple': 1, then 2
# 'banana': 1, then 2
# 'kiwi': 1
# 'grapefruit': 1
# 'orange': 1
# Word frequencies: {'apple': 2, 'banana': 2, 'kiwi': 1, 'grapefruit': 1, 'orange': 1}
```

-----

## 4\. **Unique Words from String**

**Problem:** Extract and return a list of unique words from the `text` string.

**🔧 Code:**

```python
text = "Hello world hello Python and python"

# Convert to lowercase to treat "Hello" and "hello" as the same word
# Split the string into words. `split()` without arguments handles multiple spaces.
raw_words = text.lower().split()

unique_words = []
for word in raw_words:
    if word not in unique_words:
        unique_words.append(word)

print(f"Unique words: {unique_words}")

# ✅ Output:
# Lowercase words: ['hello', 'world', 'hello', 'python', 'and', 'python']
# 'hello' added.
# 'world' added.
# 'hello' skipped.
# 'python' added.
# 'and' added.
# 'python' skipped.
# Unique words: ['hello', 'world', 'python', 'and']
```

-----

## 5\. **Count Vowels in Text**

**Problem:** Write a program to count the total number of vowels in the `text` string.

**🔧 Code:**

```python
text = "Programming is fun"
vowels = "aeiouAEIOU"
vowel_count = 0

for char in text:
    if char in vowels:
        vowel_count += 1

print(f"Total vowels: {vowel_count}")

# ✅ Output:
# P r o g r a m m i n g   i s   f u n
# Vowels: o (1), a (1), i (1), i (2), u (1) → Total 5
```

-----

## 6\. **Check if Any Word is a Palindrome**

**Problem:** From the `words` list, check if any word is a palindrome.

**🔧 Code:**

```python
words = ["level", "hello", "madam", "world", "radar"]

found_palindrome = False
for word in words:
    # Check if word is equal to its reverse
    if word == word[::-1]: # Using slicing for word reversal
        print(f"'{word}' is a palindrome.")
        found_palindrome = True

if not found_palindrome:
    print("No palindromes found in the list.")

# ✅ Output:
# 'level' is a palindrome.
# 'madam' is a palindrome.
# 'radar' is a palindrome.
```

-----

## 7\. **Filter Words Longer Than 5 Characters**

**Problem:** Write code to filter and return only those words from `words` list that are longer than 5 characters.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "grapefruit", "orange"]

long_words = []
for word in words:
    if len(word) > 5:
        long_words.append(word)

print(f"Words longer than 5 characters: {long_words}")

# ✅ Output:
# "apple" (5 chars) - No
# "banana" (6 chars) - Yes
# "kiwi" (4 chars) - No
# "grapefruit" (10 chars) - Yes
# "orange" (6 chars) - Yes
# Words longer than 5 characters: ['banana', 'grapefruit', 'orange']
```

-----

## 8\. **Most Frequent Word in List**

**Problem:** Write code to identify the most frequently occurring word in the `words` list.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "apple", "grapefruit", "banana", "apple", "orange"]

word_counts = {}
for word in words:
    word_counts[word] = word_counts.get(word, 0) + 1

most_frequent_word = None
max_count = 0

if word_counts: # Ensure dictionary is not empty
    # Iterate through the dictionary items to find the word with max count
    for word, count in word_counts.items():
        if count > max_count:
            max_count = count
            most_frequent_word = word

print(f"The most frequent word is: '{most_frequent_word}' (appears {max_count} times)")

# ✅ Output:
# Word counts: {'apple': 3, 'banana': 2, 'kiwi': 1, 'grapefruit': 1, 'orange': 1}
# max_count starts at 0, most_frequent_word is None
# 'apple': count 3. max_count=3, most_frequent_word='apple'
# 'banana': count 2. No change.
# ...
# The most frequent word is: 'apple' (appears 3 times)
```

-----

## 9\. **Remove Duplicate Words from List**

**Problem:** Remove all duplicate entries from the `words` list while maintaining the order.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "apple", "grapefruit", "banana", "apple", "orange"]

seen_words = []
unique_ordered_words = []

for word in words:
    if word not in seen_words:
        seen_words.append(word)
        unique_ordered_words.append(word)

print(f"List with duplicates removed (order preserved): {unique_ordered_words}")

# ✅ Output:
# 'apple': add. seen=['apple'], unique=['apple']
# 'banana': add. seen=['apple','banana'], unique=['apple','banana']
# 'kiwi': add. seen=['apple','banana','kiwi'], unique=['apple','banana','kiwi']
# 'apple': skip (in seen)
# 'grapefruit': add. seen=[... 'grapefruit'], unique=[... 'grapefruit']
# 'banana': skip (in seen)
# 'apple': skip (in seen)
# 'orange': add. seen=[... 'orange'], unique=[... 'orange']
# List with duplicates removed (order preserved): ['apple', 'banana', 'kiwi', 'grapefruit', 'orange']
```

-----

## 10\. **Total Character Count in List**

**Problem:** Calculate the total number of characters (excluding spaces) across all words in the `words` list.

**🔧 Code:**

```python
words = ["apple", "banana pie", "kiwi"] # Example with spaces in a word

total_char_count = 0

for word in words:
    for char in word:
        if char != ' ':
            total_char_count += 1

print(f"Total character count (excluding spaces): {total_char_count}")

# ✅ Output:
# "apple": 5 chars
# "banana pie": 9 chars ('banana', 'p', 'i', 'e')
# "kiwi": 4 chars
# Total: 5 + 9 + 4 = 18
```

-----

## 11\. **Count How Many Words Start with a Vowel**

**Problem:** Write code to count how many words in the `words` list start with a vowel.

**🔧 Code:**

```python
words = ["apple", "Orange", "banana", "kiwi", "umbrella", "Elephant"]
vowels = "aeiouAEIOU" # Include both uppercase and lowercase vowels

vowel_start_count = 0

for word in words:
    if word and word[0] in vowels: # Check if word is not empty and its first char is a vowel
        vowel_start_count += 1

print(f"Number of words starting with a vowel: {vowel_start_count}")

# ✅ Output:
# "apple" - Yes
# "Orange" - Yes
# "banana" - No
# "kiwi" - No
# "umbrella" - Yes
# "Elephant" - Yes
# Number of words starting with a vowel: 4
```

-----

## 12\. **Convert List to Sentence**

**Problem:** Convert the `words` list into a single space-separated sentence string.

**🔧 Code:**

```python
words = ["This", "is", "a", "sentence", "example"]

sentence = " ".join(words)

print(f"Converted sentence: '{sentence}'")

# ✅ Output:
# Converted sentence: 'This is a sentence example'
```

-----

## 13\. **Print Words Ending with a Specific Character**

**Problem:** Write a loop to print all words in the `words` list that end with the letter 'e'.

**🔧 Code:**

```python
words = ["apple", "orange", "grape", "banana", "house", "table"]

print("Words ending with 'e':")
for word in words:
    # Check if the word is not empty and its last character (lowercase) is 'e'
    if word and word[-1].lower() == 'e':
        print(word)

# ✅ Output:
# Words ending with 'e':
# apple
# orange
# grape
# house
# table
```

-----

## 14\. **Create a Dictionary with Word Lengths**

**Problem:** Generate a dictionary where keys are words and values are the lengths of those words.

**🔧 Code:**

```python
words = ["cat", "dog", "elephant", "bird"]

word_lengths = {}

for word in words:
    word_lengths[word] = len(word)

print(f"Word lengths dictionary: {word_lengths}")

# ✅ Output:
# Word lengths dictionary: {'cat': 3, 'dog': 3, 'elephant': 8, 'bird': 4}
```

-----

## 15\. **Count Words in Text**

**Problem:** Split the `text` string by space and count the number of words.

**🔧 Code:**

```python
text = "Python is an amazing programming language."

# Use .split() without arguments to handle multiple spaces and strip leading/trailing spaces
words = text.split()

word_count = len(words)

print(f"The text has {word_count} words.")

# ✅ Output:
# The text has 6 words.
```

-----

## 16\. **Capitalize First Letter of Each Word in List**

**Problem:** Write code to capitalize the first letter of each word in the `words` list.

**🔧 Code:**

```python
words = ["hello", "world", "python", "programming"]

capitalized_words = []
for word in words:
    capitalized_words.append(word.capitalize()) # .capitalize() makes first char uppercase, rest lowercase

print(f"Capitalized words: {capitalized_words}")

# ✅ Output:
# Capitalized words: ['Hello', 'World', 'Python', 'Programming']
```

-----

## 17\. **Find All Words Containing a Specific Letter**

**Problem:** Print all words in the `words` list that contain the letter 'a'.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "grapefruit", "orange", "apricot"]
target_letter = 'a'

print(f"Words containing '{target_letter}':")
for word in words:
    if target_letter in word.lower(): # Check for 'a' (case-insensitive)
        print(word)

# ✅ Output:
# Words containing 'a':
# apple
# banana
# grapefruit
# orange
# apricot
```

-----

## 18\. **Replace a Specific Word in List**

**Problem:** Replace the word 'apple' with 'grape' in the `words` list.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "apple", "orange"]

old_word = "apple"
new_word = "grape"

for i in range(len(words)):
    if words[i] == old_word:
        words[i] = new_word

print(f"List after replacement: {words}")

# ✅ Output:
# Initial: ['apple', 'banana', 'kiwi', 'apple', 'orange']
# Replace words[0] with 'grape'
# Replace words[3] with 'grape'
# List after replacement: ['grape', 'banana', 'kiwi', 'grape', 'orange']
```

-----

## 19\. **Count How Many Words Have Even Length**

**Problem:** Write code to count how many words in `words` have an even number of characters.

**🔧 Code:**

```python
words = ["cat", "dog", "elephant", "bird", "table", "book"]

even_length_word_count = 0

for word in words:
    if len(word) % 2 == 0: # Check if length is even
        even_length_word_count += 1

print(f"Number of words with even length: {even_length_word_count}")

# ✅ Output:
# "cat" (3) - No
# "dog" (3) - No
# "elephant" (8) - Yes
# "bird" (4) - Yes
# "table" (5) - No
# "book" (4) - Yes
# Number of words with even length: 3
```

-----

## 20\. **Remove Words Containing a Specific Letter**

**Problem:** Remove all words from the `words` list that contain the letter 'e'.

**🔧 Code:**

```python
words = ["apple", "banana", "kiwi", "grape", "orange", "cat"]
letter_to_remove = 'e'

# Create a new list to store words that don't contain the letter
filtered_words = []
for word in words:
    # Check if the lowercase version of the word contains the letter
    if letter_to_remove.lower() not in word.lower():
        filtered_words.append(word)

print(f"Words after filtering: {filtered_words}")

# ✅ Output:
# "apple" - contains 'e', removed
# "banana" - no 'e', kept
# "kiwi" - no 'e', kept
# "grape" - contains 'e', removed
# "orange" - contains 'e', removed
# "cat" - no 'e', kept
# Words after filtering: ['banana', 'kiwi', 'cat']
```