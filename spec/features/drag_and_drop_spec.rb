require 'spec_helper'

describe 'drag and drop', :type => :feature, :js => true do
  context 'existing things' do
    before(:each) { Thing.delete_all }

    let!(:thing1) { Thing.create }
    let!(:thing2) { Thing.create }

    describe 'drag up' do
      let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
      let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

      subject do
        draggable = find(thing1_selector)
        droppable = find(thing2_selector)

        draggable.drag_to(droppable)

        click_button 'Refresh'
      end

      it 'change first thing position to 0' do
        visit '/'
        subject
        expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing1.id}' and @data-position='0']")
      end

      it 'change second thing position to 1' do
        visit '/'
        subject
        expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing2.id}' and @data-position='1']")
      end
    end

    describe 'drag down' do
      let!(:thing1) { Thing.create }
      let!(:thing2) { Thing.create }

      let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
      let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

      subject do
        page.execute_script %Q{
          var draggable = $('#{thing2_selector}');
          var droppable = $('#{thing1_selector}');
          var dy = droppable.offset().top - draggable.offset().top + 10;

          draggable.simulate('drag', {dx:0, dy: dy});
        }
        click_button 'Refresh'
      end

      it 'change first thing position to 0' do
        visit '/'
        subject
        expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing1.id}' and @data-position='#{thing1.sortable_append ? 1 : 0}']")
      end

      it 'change second thing position to 1' do
        visit '/'

        child1 = find(thing1_selector)
        p "#{child1.text} - #{child1['data-position']}"
        child2 = find(thing2_selector)
        p "#{child2.text} - #{child2['data-position']}"

        subject

        p '---'

        child1 = find(thing1_selector)
        p "#{child1.text} - #{child1['data-position']}"
        child2 = find(thing2_selector)
        p "#{child2.text} - #{child2['data-position']}"

        expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing2.id}' and @data-position='#{thing2.sortable_append ? 0 : 1}']")
      end
    end
  end

  context 'new things' do
    let(:new_parent_path) { '/parents/new' }

    describe 'drag up' do
      let(:child1_selector) { "li[data-position='2']" }
      let(:child2_selector) { "li[data-position='0']" }

      subject do
        draggable = find(child1_selector)
        droppable = find(child2_selector)

        draggable.drag_to(droppable)

        click_button 'Create Parent'
      end

      it 'change first child position to 2' do
        visit new_parent_path
        subject
        expect(page).to have_selector("li[data-position='1']", :text => 'Child 0')
      end

      it 'change last child position to 0' do
        visit new_parent_path
        subject
        expect(page).to have_selector("li[data-position='0']", :text => 'Child 2')
      end
    end

    describe 'drag down' do
      let(:child1_selector) { "li[data-position='2']" }
      let(:child2_selector) { "li[data-position='0']" }

      subject do
        page.execute_script %Q{
          var draggable = $("#{child2_selector}");
          var droppable = $("#{child1_selector}");
          var dy = droppable.offset().top - draggable.offset().top + 1;

          draggable.simulate('drag', {dx:0, dy: dy});
        }

        click_button 'Create Parent'
      end

      it 'change first child position to 2' do
        visit new_parent_path
        subject
        expect(page).to have_selector("li[data-position='2']", :text => 'Child 0')
      end

      it 'change middle child position to 0' do
        visit new_parent_path
        subject
        expect(page).to have_selector("li[data-position='0']", :text => 'Child 1')
      end

      it 'change last child position to 1' do
        visit new_parent_path
        subject
        expect(page).to have_selector("li[data-position='1']", :text => 'Child 2')
      end
    end
  end
end
