// Copyright 2006-2008 The RE2 Authors.  All Rights Reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <stdint.h>
#include <fstream>
#include <string>

#include "re2/prog.h"
#include "re2/re2.h"
#include "re2/regexp.h"

static constexpr bool kVerbose = true;

int get_num_states(std::string regex, size_t &dfa_states, size_t &nfa_states) {
  re2::Regexp *re = re2::Regexp::Parse(regex, re2::Regexp::LikePerl, NULL);
  if (re == nullptr) {
    if (kVerbose) printf("failed to parse regex %s\n", regex.c_str());
    return -1;
  }
  re2::Prog *prog = re->CompileToProg(0);
  if (prog == nullptr) {
    if (kVerbose) printf("failed to compile regex %s\n", regex.c_str());
    return -1;
  }

  dfa_states = prog->BuildEntireDFA(re2::Prog::kFirstMatch, nullptr);
  nfa_states = prog->inst_count(re2::InstOp::kInstByteRange);
  printf("program =\n%s\n", prog->Dump().c_str());

  return 0;
}

void basic_test() {
  size_t dfa_states = 0, nfa_states = 0;

  get_num_states("a", dfa_states, nfa_states);
  assert(dfa_states == 3);

  get_num_states("ab", dfa_states, nfa_states);
  assert(dfa_states == 4);

  get_num_states("(a|b)*abb(a|b)*", dfa_states, nfa_states);
  assert(dfa_states == 10);
}

int main() {
  basic_test();

  std::ifstream in("akalia/dataset.txt");

  std::string s;
  s.reserve(1000);  // For performance

  while (true) {
    std::getline(in, s);
    if (s.empty()) break;

    s = s.substr(0, s.length() - 1);

    size_t dfa_states = 0, nfa_states = 0;
    int ret = get_num_states(s, dfa_states, nfa_states);
    if (ret == -1) continue;

    printf("dfa %zu, nfa %zu, regex %s\n\n\n", dfa_states, nfa_states,
           s.c_str());
  }
}
