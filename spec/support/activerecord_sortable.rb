shared_examples 'activerecord-sortable' do |options = {}|
  position_column = options[:position_column] || :position

  describe '.create' do
    context 'appending' do
      before(:each) do
        described_class.delete_all

        described_class.sortable_append = true
      end

      let!(:thing1) { described_class.create }

      subject { described_class.create }

      it 'should have position eq 1' do
        expect(subject.send(position_column)).to eq(1)
      end

      it 'should not change first thing updated_at' do
        expect { subject }.not_to change { thing1.reload.updated_at }
      end
    end

    context 'prepending' do
      before(:each) do
        described_class.delete_all

        described_class.sortable_append = false
      end

      let!(:thing1) { described_class.create }

      subject { described_class.create }

      it 'should have position eq 0' do
        expect(subject.send(position_column)).to eq(0)
      end

      context 'touch is on' do
        it 'should change first thing updated_at' do
          expect { subject }.to change { thing1.reload.updated_at }
        end
      end

      context 'touch is off' do
        before { described_class.sortable_touch = false }

        it 'should not change first thing updated_at' do
          expect { subject }.not_to change { thing1.reload.updated_at }
        end

        after { described_class.sortable_touch = true }
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      described_class.delete_all

      described_class.sortable_append = true
    end

    let!(:thing1) { described_class.create }
    let!(:thing2) { described_class.create }

    subject { thing1.destroy }

    it 'shifts next records' do
      expect { subject }.to change { thing2.reload.send(position_column) }.to(0)
    end

    it 'change next record updated_at' do
      expect { subject }.to change { thing2.reload.updated_at }
    end
  end

  describe 'scopes' do
    before(:each) do
      described_class.delete_all

      described_class.sortable_append = true
    end

    let!(:thing1) { described_class.create }
    let!(:thing2) { described_class.create }

    subject { described_class }

    it 'should orders' do
      expect(subject.send("ordered_by_#{position_column}_asc".to_sym)).to match_array([thing1, thing2])
    end
  end

  describe '#move_to!' do
    before(:each) do
      described_class.delete_all

      described_class.sortable_append = true
    end

    let!(:thing1) { described_class.create }
    let!(:thing2) { described_class.create }
    let!(:thing3) { described_class.create }

    context 'prev' do
      subject { thing3.move_to!(1) }

      it "should change thing3 #{position_column} to 1" do
        expect { subject }.to change { thing3.reload.send(position_column) }.to(1)
      end

      it 'should change thing3 updated_at' do
        expect { subject }.to change { thing3.reload.updated_at }
      end

      it "should change thing2 #{position_column} to 2" do
        expect { subject }.to change { thing2.reload.send(position_column) }.to(2)
      end

      it 'should change thing2 updated_at' do
        expect { subject }.to change { thing2.reload.updated_at }
      end

      it 'should not change thing1 updated_at' do
        expect { subject }.not_to change { thing1.reload.updated_at }
      end
    end

    context 'next' do
      subject { thing1.move_to!(1) }

      it "should change thing1 #{position_column} to 1" do
        expect { subject }.to change { thing1.reload.send(position_column) }.to(1)
      end

      it 'should change thing1 updated_at' do
        expect { subject }.to change { thing1.reload.updated_at }
      end

      it "should change thing2 #{position_column} to 0" do
        expect { subject }.to change { thing2.reload.send(position_column) }.to(0)
      end

      it 'should change thing2 updated_at' do
        expect { subject }.to change { thing2.reload.updated_at }
      end

      it 'should not change thing3 updated_at' do
        expect { subject }.not_to change { thing3.reload.updated_at }
      end
    end

    subject { thing3.move_to!(2) }
  end
end
