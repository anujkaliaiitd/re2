// Copyright 2006-2008 The RE2 Authors.  All Rights Reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <stdint.h>
#include <string>
#include <fstream>

#include "re2/prog.h"
#include "re2/re2.h"
#include "re2/regexp.h"

size_t get_num_states(std::string regex) {
  re2::Regexp *re = re2::Regexp::Parse(regex, re2::Regexp::LikePerl, NULL);
  if (re == nullptr) {
    printf("failed to parse regex %s\n", regex.c_str());
    return 0;
  }
  re2::Prog *prog = re->CompileToProg(0);
  if (prog == nullptr) {
    printf("failed to compile regex %s\n", regex.c_str());
    return 0;
  }

  return prog->BuildEntireDFA(re2::Prog::kFirstMatch, nullptr);
}

int main() {
  assert(get_num_states("a") == 3);
  assert(get_num_states("ab") == 4);
  assert(get_num_states("(a|b)*abb(a|b)*") == 10);

  std::ifstream in("akalia/dataset.txt");

  std::string s;
  s.reserve(1000);  // For performance

  while (true) {
    std::getline(in, s);
    if (s.empty()) break;
    printf("regex %s, states %zu\n", s.c_str(), get_num_states(s));
  }
}
