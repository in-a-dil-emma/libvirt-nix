import re

# Copyright 2024 Paul Durivage 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# https://gist.github.com/angstwad/bf22d1822c38a92ec0a9
# changes: type annotations, removed unused variables, indentation, list merges
def dict_merge(dct: dict, merge_dct: dict):
    """ Recursive dict merge. Inspired by :meth:``dict.update()``, instead of
    updating only top-level keys, dict_merge recurses down into dicts nested
    to an arbitrary depth, updating keys. The ``merge_dct`` is merged into
    ``dct``.
    :param dct: dict onto which the merge is executed
    :param merge_dct: dct merged into dct
    :return: None
    """
    for k in merge_dct:
      if (k in dct and isinstance(dct[k], dict) and isinstance(merge_dct[k], dict)):  #noqa
        dict_merge(dct[k], merge_dct[k])
      elif isinstance(dct[k], list) and isinstance(merge_dct[k], list):
        dct[k].extend(merge_dct[k])
      else:
        dct[k] = merge_dct[k]

# partially vibe coded, very likely bad code
def filter_strings(a: list[str], b: list[str]) -> list[str]:
  compiled_patterns = []

  for item in b:
    try:
      compiled_patterns.append(re.compile(item))
    except re.error:
      # not a regex ig
      continue

  result = []
  for string in a:
    if string in b:
      result.append(string)
    elif any(pattern.fullmatch(string) for pattern in compiled_patterns):
      result.append(string)

  return result