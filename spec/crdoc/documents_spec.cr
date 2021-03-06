require "../spec_helper"

describe Crdoc::Documents do
  r = Crdoc::Repository.new TEST_CONFIG_PATH
  d = Crdoc::Documents.new(TEST_CONFIG_PATH, r)

  describe "cache!" do
    it "make a cache" do
      c = d.cache!
      d.cached?.should be_true
      c[:api]?.should_not be_nil
      c[:syntax_and_semantics]?.should_not be_nil
      c[:api].size.should_not eq(0)
      c[:syntax_and_semantics].size.should_not eq(0)
    end
  end

  describe "delete_cache" do
    it "deletes cache if exist" do
      d.cache! unless d.cached?
      d.delete_cache
      d.cached?.should be_false
    end

    it "does nothing if cache does not exist" do
      d.delete_cache if d.cached?
      d.delete_cache
      d.cached?.should be_false
    end
  end

  describe "cache" do
    it "makes a cache if not exist" do
      d.delete_cache if d.cached?
      c = d.cache
      d.cached?.should be_true
      c[:api]?.should_not be_nil
      c[:syntax_and_semantics]?.should_not be_nil
      c[:api].size.should_not eq(0)
      c[:syntax_and_semantics].size.should_not eq(0)
    end

    it "loads cache if it is available" do
      d.cache! unless d.cached?
      c = d.cache
      d.cached?.should be_true
      c[:api]?.should_not be_nil
      c[:syntax_and_semantics]?.should_not be_nil
      c[:api].size.should_not eq(0)
      c[:syntax_and_semantics].size.should_not eq(0)
    end
  end

  describe "list" do
    it "returns list of API candidates if :api is specified" do
      la = d.list :api
      la.size.should_not eq(0)
    end

    it "returns list of language spec candidates if :syntax_and_semantics is specified" do
      lss = d.list :syntax_and_semantics
      lss.size.should_not eq(0)
    end

    it "returns list of all candidates if nothing specified" do
      la = d.list :api
      lss = d.list :syntax_and_semantics
      l = d.list

      l.size.should eq(la.size + lss.size)
    end
  end

  describe "list_paths" do
    it "returns list of path to HTML document instead of candidates" do
      la = d.list_paths :api
      lss = d.list_paths :syntax_and_semantics
      l = d.list_paths

      la.all?(&.ends_with? ".html").should be_true
      lss.all?(&.ends_with? ".html").should be_true
      l.all?(&.ends_with? ".html").should be_true
    end
  end

  describe "candidates" do
    it "returns kind-specific candidates if kind is specified" do
      d.cache! unless d.cached?
      c = d.candidates :api
      c.empty?.should be_false
      c = d.candidates :syntax_and_semantics
      c.empty?.should be_false
    end

    it "returns all candidates if nothing is specified" do
      d.cache! unless d.cached?
      d.candidates.empty?.should be_false
    end
  end

end
