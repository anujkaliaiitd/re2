// Copyright 2006-2008 The RE2 Authors.  All Rights Reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <stdint.h>
#include <string>
#include <thread>
#include <vector>

#include "re2/prog.h"
#include "re2/re2.h"
#include "re2/regexp.h"

int main() {
  std::string s = "a";
  re2::Regexp *re = re2::Regexp::Parse(s, re2::Regexp::LikePerl, NULL);
  re2::Prog *prog = re->CompileToProg(0);

  size_t num_states = prog->BuildEntireDFA(re2::Prog::kFirstMatch, nullptr);
  printf("Anuj: num_states = %zu\n", num_states);
}
