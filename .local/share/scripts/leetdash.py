import json
import os
from typing import Dict, List, Set

import requests
from bs4 import BeautifulSoup

FLARE_SOLVERR_URL = 'http://localhost:8191/v1'


class LeetCode:
  def __init__(self):
    self.all_problems = self._get_problems('all')
    self.algorithms_problems = self._get_problems('algorithms')
    self.sql_problems = self._get_problems('database')
    self.js_problems = self._get_problems('javascript')
    self.shell_problems = self._get_problems('shell')
    self.concurrency_problems = self._get_problems('concurrency')
    self.pandas_problems = self._get_problems('pandas')

  def _get_problems(self, topic: str) -> List[int]:
    headers = {'Content-Type': 'application/json'}
    data = {
        'cmd': 'request.get',
        'url': f'https://leetcode.com/api/problems/{topic}/',
        'maxTimeout': 60000
    }
    response = requests.post(url=FLARE_SOLVERR_URL, headers=headers, json=data)
    html = response.json()['solution']['response']
    soup = BeautifulSoup(html, 'html.parser')
    json_data = json.loads(soup.body.text)
    problems = json_data["stat_status_pairs"]
    problems.sort(key=lambda x: x["stat"]["frontend_question_id"])
    return problems


lc = LeetCode()

algorithms_problems_set: Set[int] = set(p['stat']['frontend_question_id']
                                        for p in lc.algorithms_problems)
sql_problems_set: Set[int] = set(p['stat']['frontend_question_id']
                                 for p in lc.sql_problems)
js_problems_set: Set[int] = set(p['stat']['frontend_question_id']
                                for p in lc.js_problems)
shell_problems_set: Set[int] = set(p['stat']['frontend_question_id']
                                   for p in lc.shell_problems)
concurrency_problems_set: Set[int] = set(p['stat']['frontend_question_id']
                                         for p in lc.concurrency_problems)
pandas_problems_set: Set[int] = set(p['stat']['frontend_question_id']
                                    for p in lc.pandas_problems)

for problem_num in sql_problems_set:
  pandas_problems_set.discard(problem_num)

solved_list = [False] * len(lc.all_problems)
solved_count = 0
solved_algorithms_count = 0
solved_cpp_count = 0
solved_java_count = 0
solved_python_count = 0
solved_sql_count = 0
solved_js_count = 0
solved_shell_count = 0
solved_concurrency_count = 0
solved_pandas_count = 0

solution_str = '/solutions/'
full_path = '/Users/Jay/Repos/LeetCode'


# Record my solving status.
for root, dirs, files in os.walk(full_path):
  if solution_str in root:
    start_index = len(full_path) + len(solution_str)
    # 1-indexed problem_num
    # e.g. 1. Two Sum -> 1
    problem_num = int(root[start_index:root.index('.')])
    if problem_num - 1 > len(lc.all_problems):
      continue
    solved_list[problem_num - 1] = True
    solved_count += 1
    if problem_num in algorithms_problems_set:
      solved_algorithms_count += 1
      if any('cpp' in file for file in files):
        solved_cpp_count += 1
      if any('java' in file for file in files):
        solved_java_count += 1
      if any('py' in file for file in files):
        solved_python_count += 1
    elif problem_num in sql_problems_set:
      sql_problems_set.remove(problem_num)
      solved_sql_count += 1
    elif problem_num in js_problems_set:
      js_problems_set.remove(problem_num)
      solved_js_count += 1
    elif problem_num in shell_problems_set:
      shell_problems_set.remove(problem_num)
      solved_shell_count += 1
    elif problem_num in concurrency_problems_set:
      concurrency_problems_set.remove(problem_num)
      solved_concurrency_count += 1
    else:  # problem_num in pandas_problems_set
      pandas_problems_set.remove(problem_num)
      solved_pandas_count += 1


not_solved_algorithms_easy_ids = []
not_solved_algorithms_medium_ids = []
not_solved_algorithms_hard_ids = []


def _get_problem_id(problem_id: int, paid_only: bool):
  if paid_only:
    return str(problem_id) + '🔒'
  return problem_id


# Record unsolved Algorithm problems.
for i, solved in enumerate(solved_list):
  if solved:
    continue
  problem_id = i + 1
  level = lc.all_problems[i]['difficulty']['level']
  paid_only = lc.all_problems[i]['paid_only']
  if problem_id in algorithms_problems_set:
    match level:
      case 1:
        not_solved_algorithms_easy_ids.append(
            _get_problem_id(problem_id, paid_only))
      case 2:
        not_solved_algorithms_medium_ids.append(
            _get_problem_id(problem_id, paid_only))
      case 3:
        not_solved_algorithms_hard_ids.append(
            _get_problem_id(problem_id, paid_only))


print('Problems Count')
print('{:<4} (All) = {:<4} (Algorithms) + {:<3} (SQL) + {:<2} (JavaScript) + {:<1} (Shell) + {:<1} (Concurrency)'.format(
    len(lc.all_problems),
    len(lc.algorithms_problems),
    len(lc.sql_problems),
    len(lc.js_problems),
    len(lc.shell_problems),
    len(lc.concurrency_problems)))

print()
print('Progress')
print('{:<4} (All) = {:<4} (Algorithms) + {:<3} (SQL) + {:<2} (JavaScript) + {:<1} (Shell) + {:<1} (Concurrency)'.format(
    solved_count,
    solved_algorithms_count,
    solved_sql_count,
    solved_js_count,
    solved_shell_count,
    solved_concurrency_count))

print()
print('Percentage')
print('{0}/{1} = {2}%'.format(solved_count, len(lc.all_problems),
      round(solved_count / len(lc.all_problems) * 100, 2)))


# print()
# print('Language Metadata')
# print('C++: {0} | Java: {1} | Python: {2}'.format(
#     solved_cpp_count, solved_java_count, solved_python_count))

# print()
# print('Not solved algorithms: {0} - {1} = {2}'.format(
#     len(lc.algorithms_problems),
#     solved_algorithms_count,
#     len(lc.algorithms_problems) - solved_algorithms_count))

if not_solved_algorithms_easy_ids:
  print()
  print('Easy: {}'.format(not_solved_algorithms_easy_ids))

if not_solved_algorithms_medium_ids:
  print()
  print('Medium: {}'.format(not_solved_algorithms_medium_ids))

if not_solved_algorithms_hard_ids:
  print()
  print('Hard: {}'.format(not_solved_algorithms_hard_ids))

if sql_problems_set:
  print()
  print('SQL')
  print(sorted(sql_problems_set))

if js_problems_set:
  print()
  print('JavaScript')
  print(sorted(js_problems_set))

if shell_problems_set:
  print()
  print('Shell')
  print(sorted(shell_problems_set))

if concurrency_problems_set:
  print()
  print('Concurrency')
  print(sorted(concurrency_problems_set))

if pandas_problems_set:
  print()
  print('Pandas')
  print(sorted(pandas_problems_set))


def count_language_files(directory: str) -> Dict[str, int]:
    # Define the file extensions for each programming language
  extensions = {
      '.cpp': 'C++',
      '.java': 'Java',
      '.py': 'Python',
      '.ts': 'TypeScript',
      '.sql': 'MySQL',
      '.sh': 'Bash'
  }

  # Initialize a dictionary to hold the count for each language
  language_count = {'C++': 0, 'Java': 0,
                    'Python': 0, 'TypeScript': 0, 'MySQL': 0, 'Bash': 0}

  # Iterate over all files in the given directory
  for root, dirs, files in os.walk(directory):
    for file in files:
      # Get the file extension and update the count for the corresponding language
      _, ext = os.path.splitext(file)
      if ext in extensions:
        language_count[extensions[ext]] += 1

  return language_count


def print_markdown_table(language_count):
    # Determine the maximum width of the language name and file count columns
  max_language_length = max(len(language)
                            for language in language_count.keys())
  max_count_length = max(len(str(count)) for count in language_count.values())

  # Ensure minimum width for headers
  max_language_length = max(max_language_length, len("Language"))
  max_count_length = max(max_count_length, len("File Count"))

  # Initialize a list to hold each line of the markdown table
  markdown_table_lines = []

  # Create the header of the markdown table with appropriate spacing and add to the list
  header = "| {:<{}} | {:<{}} |".format(
      "Language", max_language_length, "File Count", max_count_length)
  separator = "|{}|{}|".format(
      '-' * (max_language_length + 2), '-' * (max_count_length + 2))
  markdown_table_lines.append(header)
  markdown_table_lines.append(separator)

  # Add each language and its count to the table with appropriate spacing
  for language, count in language_count.items():
    line = "| {:<{}} | {:<{}} |".format(
        language, max_language_length, count, max_count_length)
    markdown_table_lines.append(line)

  return markdown_table_lines


language_counts = count_language_files(full_path + solution_str)
markdown_table_lines = print_markdown_table(language_counts)

for line in markdown_table_lines:
  print(line)

# def days_until_specific_date(year: int, month: int, day: int) -> int:
#   today = datetime.now().date()
#   specific_date = datetime(year, month, day).date()
#   days_remaining = (specific_date - today).days
#   return days_remaining


# target_year = 2023
# target_month = 12
# target_day = 31
# days_to_20231231 = days_until_specific_date(
#     target_year, target_month, target_day)

# print()
# print(
#     f"Days until {target_year}-{target_month:02d}-{target_day:02d}: {days_to_20231231} days")

# print()
# print('Problems per day as of {}: {}'.format(
#     datetime.now().date(),
#     round((len(lc.all_problems) - solved_count) / days_to_20231231, 2)))
