class AssertionFailure < RuntimeError; end

def assert(got, want)
  return if got == want

  raise AssertionFailure, "Got #{got.inspect}, want #{want.inspect}"
end
