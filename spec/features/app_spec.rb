require 'spec_helper'

describe 'drag and drop', :type => :feature, :js => true do
  before(:each) { Thing.delete_all }

  describe 'drag up' do
    let!(:thing1) { Thing.create }
    let!(:thing2) { Thing.create }

    let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
    let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

    subject do
      draggable = find(thing1_selector)
      droppable = find(thing2_selector)

      draggable.drag_to(droppable)
    end

    it 'change first thing position to 0' do
      visit '/'
      expect { subject }.to change{find(thing1_selector)['data-position']}.from("1").to("0")
    end

    it 'change second thing position to 1' do
      visit '/'
      expect { subject }.to change{find(thing2_selector)['data-position']}.from("0").to("1")
    end
  end

  describe 'drag down' do
    let!(:thing1) { Thing.create }
    let!(:thing2) { Thing.create }

    let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
    let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

    subject do
      page.execute_script %Q{
        $.getScript("/assets/jquery.simulate.js", function(){
          var draggable = $('#{thing2_selector}');
          var droppable = $('#{thing1_selector}');
          var dy = droppable.offset().top - draggable.offset().top + 1;

          draggable.simulate('drag', {dx:0, dy: dy});
        });
      }
    end

    it 'change first thing position to 0' do
      visit '/'
      expect { subject }.to change{find(thing1_selector)['data-position']}.from("1").to("0")
    end

    it 'change second thing position to 1' do
      visit '/'
      expect { subject }.to change{find(thing2_selector)['data-position']}.from("0").to("1")
    end
  end
end
