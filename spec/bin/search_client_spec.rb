# require 'rspec'
require 'open3'
require 'pry'

RSpec.describe 'search_client command line script' do
  let(:json_file) { 'spec/fixtures/clients.json' }
  let(:unique_file) { 'spec/fixtures/unique_clients.json' }
  let(:script) { 'bin/search_client' }

  describe 'query command' do
    context 'by name' do
      it 'prints matched clients from default json file' do
        output, status = Open3.capture2(script, 'query', '--field', 'name', '--value', 'Another')
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('Jane Smith')
        expect(output).not_to include('Joe Kelly')
      end

      it 'prints matched clients from provided json file' do
        output, status = Open3.capture2(script, 'query', '--field', 'name', '--value', 'joe', '--file', json_file)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('Joe Kelly')
        expect(output).not_to include('Another Jane Smith')
      end

      it "returns no results when query has no match" do
        output, status = Open3.capture2(script, 'query', "--field", 'name', '--value', 'smiths')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results')
      end

      it 'prints usage message when field option is not provided' do
        output, status = Open3.capture2(script, 'query', "--value", 'Name')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_client query --field=FIELD --value=VALUE --file=FILE')
      end

      it 'prints usage message when value option is not provided' do
        output, status = Open3.capture2(script, 'query', "--field", 'name')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_client query --field=FIELD --value=VALUE --file=FILE')
      end
    end

    context 'by email' do
      it 'prints matched clients from default file' do
        output, status = Open3.capture2(script, 'query', '--field', 'email', '--value', 'smith@yahoo')
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('jane.smith@yahoo.com')
        expect(output).not_to include('joe.kelly@yahoo.com')
      end

      it 'prints matched clients from provided file' do
        output, status = Open3.capture2(script, 'query', '--field', 'email', '--value', 'joe', '--file', json_file)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('joe.kelly@yahoo.com')
        expect(output).not_to include('jane.smith@yahoo.com')
      end

      it 'returns no results when query has no match' do
        output, status = Open3.capture2(script, 'query', "--field", 'email', '--value', 'smiths')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results')
      end

      it 'prints usage message when field is not provided' do
        output, status = Open3.capture2(script, 'query', "--value", 'email@email.com')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_client query --field=FIELD --value=VALUE --file=FILE')
      end

      it 'prints usage message when value is not provided' do
        output, status = Open3.capture2(script, 'query', "--field", 'email')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_client query --field=FIELD --value=VALUE --file=FILE')
      end
    end

    context 'with missing and invalid options' do
      it 'prints invalid option error' do
        output, status = Open3.capture2(script, 'query', "--fieldx", 'id')

        expect(status.exitstatus).to eq(1)
        expect(output).to include('invalid option')
      end

      it 'prints missing argument error' do
        output, status = Open3.capture2(script, 'query', "--field")

        expect(status.exitstatus).to eq(1)
        expect(output).to include('missing argument')
      end

      it 'prints usage message' do
        output, status = Open3.capture2(script, 'query')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_client query --field=FIELD --value=VALUE --file=FILE')
      end
    end
  end

  describe 'duplicate command' do
    context 'by name' do
      it 'prints matched clients from default json file' do
        output, status = Open3.capture2(script, 'find_duplicates', '--field', 'name')
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('James Wilson')
        expect(output).not_to include('Joe Kelly')
      end

      it 'prints matched clients from provided json file' do
        output, status = Open3.capture2(script, 'find_duplicates', '--field', 'name', '--file', json_file)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('Joe Kelly')
        expect(output).not_to include('James Wilson')
      end

      it 'returns no results when query has no match' do
        output, status = Open3.capture2(script, 'find_duplicates', "--field", 'name', '--file', unique_file)

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results')
      end
    end

    context 'by email' do
      it 'prints matched clients from default file' do
        output, status = Open3.capture2(script, 'find_duplicates', '--field', 'email')
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('jane.smith@yahoo.com')
        expect(output).not_to include('joe.kelly@yahoo.com')
      end

      it 'prints matched clients from provided file' do
        output, status = Open3.capture2(script, 'find_duplicates', '--field', 'email', '--file', json_file)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('john.doe@gmail.com')
        expect(output).not_to include('jane.smith@yahoo.com')
      end

      it 'returns no results when query has no match' do
        output, status = Open3.capture2(script, 'find_duplicates', "--field", 'email', '--file', unique_file)

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results')
      end
    end

    context 'with missing and invalid options' do
      it 'prints invalid option error' do
        output, status = Open3.capture2(script, 'find_duplicates', "--fieldx", 'id')

        expect(status.exitstatus).to eq(1)
        expect(output).to include('invalid option')
      end

      it 'prints missing argument error' do
        output, status = Open3.capture2(script, 'find_duplicates', "--field")

        expect(status.exitstatus).to eq(1)
        expect(output).to include('missing argument')
      end

      it 'prints usage message' do
        output, status = Open3.capture2(script, 'find_duplicates')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_client find_duplicates --field=FIELD --file=FILE')
      end
    end
  end
end
