# frozen_string_literal: false

RSpec.describe Starter::BaseFile do
  let(:single) { 'foo' }
  let(:plural) { 'foos' }

  subject do
    Class.new do
      extend Starter::Names
      extend Starter::BaseFile
    end
  end

  describe 'on add! call' do
    describe 'add|remove mount_point' do
      before do
        allow(subject).to receive(:klass_name).and_return('bar')
      end

      let(:base_without_resource) do
        "mount Endpoints::Root

         mount Endpoints::Foo
        "
      end

      let(:base_with_resource) do
        "mount Endpoints::Root

         mount Endpoints::Foo
         mount Endpoints::#{subject.klass_name}
        "
      end

      describe '#add_to_base' do
        specify do
          expect(subject.send(:add_to_base, base_without_resource)).to include subject.mount_point
        end
      end

      describe '#remove_from_base' do
        specify do
          expect(subject.send(:remove_from_base, base_with_resource)).not_to include subject.mount_point
        end
      end
    end
  end

  describe 'get api base configuration' do
    let!(:created_api) { File.join(Dir.getwd, subject.destination) }

    before do
      FileUtils.cd(created_api)
    end

    after do
      FileUtils.cd('..')
      FileUtils.remove_dir(created_api, true)
    end

    describe 'prefix not given' do
      before(:each) do
        FileUtils.rm_f(File.join(created_api, '.config'))
      end

      subject do
        starter_gem = Gem::Specification.find_by_name('grape-starter').gem_dir
        src = File.join(starter_gem, 'template', '.')
        Starter::Builder.new!(plural, src, plural, p: nil)
      end

      describe 'base_prefix' do
        specify do
          expect(subject.base_prefix).to eql nil
        end
      end
    end

    describe 'prefix given' do
      subject do
        starter_gem = Gem::Specification.find_by_name('grape-starter').gem_dir
        src = File.join(starter_gem, 'template', '.')
        Starter::Builder.new!(plural, src, plural, p: 'awesome_api')
      end

      describe 'base_version' do
        specify do
          expect(subject.base_version).to eql 'v1'
        end
      end

      describe 'base_prefix' do
        specify do
          expect(subject.base_prefix).to eql 'awesome_api'
        end
      end
    end
  end
end
