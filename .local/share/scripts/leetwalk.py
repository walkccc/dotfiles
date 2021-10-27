import json
import os
from typing import List, Set

import requests
from bs4 import BeautifulSoup

FLARE_SOLVERR_URL = 'http://localhost:8191/v1'


class LeetCode:
  def __init__(self):
    self.all_problems = self._get_problems('all')
    self.algorithms_problems = self._get_problems('algorithms')

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
solution_str = '/solutions/'
full_path = '/Users/Jay/Repos/LeetCode'

not_solved_cpp = set()
not_solved_java = set()
not_solved_python = set()


# Record my solving status.
for root, dirs, files in os.walk(full_path):
  if solution_str in root:
    start_index = len(full_path) + len(solution_str)
    # 1-indexed problem_num
    problem_num = int(root[start_index:root.index('.')])
    if problem_num - 1 > len(lc.all_problems):
      continue
    if problem_num not in algorithms_problems_set:
      continue
    if not any('cpp' in file for file in files):
      not_solved_cpp.add(problem_num)
    if not any('java' in file for file in files):
      not_solved_java.add(problem_num)
    if not any('py' in file for file in files):
      not_solved_python.add(problem_num)


print('Not solved: C++:')
print(sorted(not_solved_cpp))
print()

print('Not solved: Java:')
print(sorted(not_solved_java))
print()

print('Not solved Python:')
print(sorted(not_solved_python))
print()
