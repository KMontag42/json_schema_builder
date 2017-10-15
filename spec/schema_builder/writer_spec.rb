require 'spec_helper'

describe SchemaBuilder::Writer do

  context 'in general' do
    before :each do
      @writer = SchemaBuilder::Writer.new
    end
    it 'should get model_path' do
      expect(@writer.model_path).to eq "#{Dir.pwd}/app/models/**/*.rb"
    end

    it 'should set model_path' do
      path = 'some/model-folder/**/*.*.rb'
      @writer.model_path = path
      expect(@writer.model_path).to eq path
    end

    it 'should get models' do
      expect(@writer.models).to include(User)
    end
  end

  context 'model naming' do
    before :each do
      @writer = SchemaBuilder::Writer.new
      @user_hash = @writer.models_as_hash.first.first
    end

    it 'should set title to model human name' do
      expect(@user_hash['title']).to eq 'User'
    end

    it 'should set name to lowercase model name' do
      expect(@user_hash['name']).to eq 'user'
    end
  end

  context 'file writing' do
    before :each do
      @writer = SchemaBuilder::Writer.new
      @writer.out_path = test_out_path
      @writer.model_path = File.join( File.expand_path( __FILE__), '../fixtures/*.rb')
      @writer.write
      @schema_file_path =  File.join(test_out_path, 'user/schema.json')
      @ui_schema_file_path =  File.join(test_out_path, 'user/ui_schema.json')
    end

    it 'should write file' do
      expect(File.exist?( @schema_file_path )).to be
      File.delete @schema_file_path
    end

    it 'writes the ui schema file' do
      expect(File.exist?(@ui_schema_file_path)).to be
      File.delete @ui_schema_file_path
    end

    it 'should write valid json' do
      hsh = JSON.parse( File.read @schema_file_path)
      expect(hsh['type']).to eq 'object'
      expect(hsh['title']).to eq 'User'
      field_names = hsh['properties'].keys
      expect(field_names).to include 'id', 'number', 'birthday', 'is_admin', 'notes'
    end

    it 'writes valid json' do
      hsh = JSON.parse( File.read @ui_schema_file_path)
      field_names = hsh.keys
      expect(field_names).to include 'id', 'number', 'birthday', 'is_admin', 'notes'
    end
  end

end
