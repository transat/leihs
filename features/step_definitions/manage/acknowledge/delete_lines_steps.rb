# -*- encoding : utf-8 -*-

When /^I delete a line of this contract$/ do
  @line = @contract.lines.first
  @line_element = find(".line", match: :prefer_exact, :text => @line.model.name)
  @line_element.find(".multibutton .dropdown-toggle").click
  @line_element.find(".multibutton .red[data-destroy-lines]", :text => _("Delete")).click
end

Then /^this contractline is deleted$/ do
  sleep(0.33)
  expect(@contract.lines.reload.include?(@line)).to be false
end

When /^I delete multiple lines of this contract$/ do
  step 'I add a model that is not already part of that contract'
  step 'I select two lines'
  if all("input[data-select-line]").map{|i| i.checked?}.all?
    find("input[data-select-line]", match: :first).click
  end
  find(".multibutton [data-selection-enabled] + .dropdown-holder").click
  find("a", :text => _("Delete Selection")).click
  find(".line", match: :first)
end

When(/^I add a model that is not already part of that contract$/) do
  @item = (@current_inventory_pool.models - @contract.models).sample.items.sample
  step 'I add a model by typing in the inventory code of an item of that model to the quick add'
end

Then /^these contractlines are deleted$/ do
  visit current_path
  expect { @line1.reload }.to raise_error(ActiveRecord::RecordNotFound)
  expect { @line2.reload }.to raise_error(ActiveRecord::RecordNotFound)
end

When /^I delete all lines of this contract$/ do
  find(".line input[type=checkbox]", match: :first)
  all(".line input[type=checkbox]").each &:click
  page.execute_script('$("#selection_actions .button").show()')
  find(".multibutton [data-selection-enabled] + .dropdown-holder").click
  find("a", :text => _("Delete Selection")).click
  find(".line", match: :first)
end

Then /^I got an error message that not all lines can be deleted$/ do
  find("#flash .error", text: _("You cannot delete all lines of an contract. Perhaps you want to reject it instead?"))
end

Then /^none of the lines are deleted$/ do
  expect(@contract.lines.count).to be > 0
end

When(/^I delete a hand over$/) do
  @visit = @current_inventory_pool.visits.hand_over.where(date: Date.today).sample
  expect(@visit.lines.empty?).to be false
  @visit_line_ids = @visit.lines.map(&:id)
  find("[data-collapsed-toggle='#hand_overs']").click unless all("[data-collapsed-toggle='#hand_overs']").empty?
  within("#hand_overs .line[data-id='#{@visit.id}']") do
    find(".line-actions .multibutton .dropdown-holder").click
    find(".dropdown-item[data-hand-over-delete]", text: _("Delete")).click
  end
end

Then(/^all lines of that hand over are deleted$/) do
  within("#hand_overs .line[data-id='#{@visit.id}']") do
    find(".line-actions .multibutton", text: _("Deleted"))
  end
  sleep(0.33)
  expect { @visit.reload }.to raise_error(ActiveRecord::RecordNotFound)
  @visit_line_ids.each do |line_id|
    expect { ContractLine.find(line_id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
