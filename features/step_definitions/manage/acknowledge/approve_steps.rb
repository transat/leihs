# -*- encoding : utf-8 -*-

When(/^I quick approve a submitted order$/) do
  @contract ||= @current_inventory_pool.contracts.submitted.shuffle.detect{|o| o.approvable? }
  find("[data-collapsed-toggle='#open-orders']").click unless all("[data-collapsed-toggle='#open-orders']").empty?
  within(".line[data-id='#{@contract.id}']") do
    find("[data-order-approve]", :text => _("Approve")).click
  end
end

Then(/^I see a link to the hand over process of that order$/) do
  find(".line[data-id='#{@contract.id}'] .line-actions a[href='#{manage_hand_over_path(@current_inventory_pool, @contract.user)}']", text: _("Hand Over"))
end

Given /^I try to approve a contract that has problems$/ do
  @contract =  @current_inventory_pool.contracts.submitted.shuffle.detect{|o| not o.approvable?}
  step "I quick approve a submitted order"
  find(".modal")
end

Then /^I got an information that this contract has problems$/ do
  find(".modal .row.emboss.red")
end

When /^I approve anyway$/ do
  within(".modal") do
    find(".dropdown-toggle").click
    find(".dropdown-item[data-approve-anyway]").click
  end
  expect(has_no_selector?(".modal")).to be true
end

Then /^this contract is approved$/ do
  find(".line[data-id='#{@contract.id}']", text: _("Approved"))
  expect(@contract.reload.status).to eq :approved
end
