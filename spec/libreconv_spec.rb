# encoding: utf-8

require 'spec_helper'
 
describe Libreconv do 
  
  before(:all) do
    @docx_file = file_path("docx.docx")
    @doc_file = file_path("doc.doc")
    @pptx_file = file_path("pptx.pptx")
    @ppt_file = file_path("ppt.ppt")
    @target_path = "/tmp/libreconv"
  end

  after(:all) do
    FileUtils.rm_rf @target_path
  end

  describe Libreconv::Converter do
    describe "#new" do
      it "should raise error if soffice command does not exists" do
        lambda { Libreconv::Converter.new(@doc_file, "/target", "/Whatever/soffice") }.should raise_error(IOError)
      end

      it "should raise error if source does not exists" do
        lambda { Libreconv::Converter.new(file_path("nonsense.txt"), "/target") }.should raise_error(IOError)
      end
    end

    describe "#convert" do
      it "should convert a doc to pdf" do
        target_file = "#{@target_path}/#{File.basename(@doc_file, ".doc")}.pdf" 
        converter = Libreconv::Converter.new(@doc_file, @target_path)
        converter.convert
        File.exists?(target_file).should == true
      end

      it "should convert a docx to pdf" do
        target_file = "#{@target_path}/#{File.basename(@docx_file, ".docx")}.pdf" 
        converter = Libreconv::Converter.new(@docx_file, @target_path)
        converter.convert
        File.exists?(target_file).should == true
      end

      it "should convert a pptx to pdf" do
        target_file = "#{@target_path}/#{File.basename(@pptx_file, ".pptx")}.pdf" 
        converter = Libreconv::Converter.new(@pptx_file, @target_path)
        converter.convert
        File.exists?(target_file).should == true
      end

      it "should convert a ppt to pdf" do
        target_file = "#{@target_path}/#{File.basename(@ppt_file, ".ppt")}.pdf" 
        converter = Libreconv::Converter.new(@ppt_file, @target_path)
        converter.convert
        File.exists?(target_file).should == true
      end

      it "should convert a docx to pdf specifying an URL as source" do
        url = "https://www.filepicker.io/api/file/XqCEPkH9RdOQr0S6zF5N"
        target_file = "#{@target_path}/XqCEPkH9RdOQr0S6zF5N.pdf"
        converter = Libreconv::Converter.new(url, @target_path)
        converter.convert
        File.exists?(target_file).should == true
      end
    end

    describe "#soffice_command" do
      it "should return the user specified command path" do
        cmd = file_path("soffice") # just faking that the command is present here
        converter = Libreconv::Converter.new(@doc_file, "/target", cmd)
        converter.soffice_command.should == cmd
      end

      it "should return the command found in path" do
        cmd = `which soffice`.strip
        converter = Libreconv::Converter.new(@doc_file, "/target")
        converter.soffice_command.should == cmd
      end
    end

    describe ".convert" do
      it "should convert a file to pdf" do
        target_file = "#{@target_path}/#{File.basename(@doc_file, ".doc")}.pdf" 
        Libreconv.convert(@doc_file, @target_path)
        File.exists?(target_file).should == true
      end
    end
  end
end