# encoding: utf-8

Wenn /^man den Kalender sieht$/ do
  step 'I open a contract for acknowledgement'
  @line_element = find(".line", match: :first)
  step 'I open the booking calendar for this line'
end

Dann /^sehe ich die Verfügbarkeit von Modellen auch an Feier\- und Ferientagen sowie Wochenenden$/ do
  while all(".fc-widget-content.holiday").empty? do
    find(".fc-button-next", match: :first).click
  end
  expect(find(".fc-widget-content.holiday .fc-day-content div", match: :first).text).not_to eq ""
  find(".fc-widget-content.holiday .fc-day-content div", match: :first).text.to_i >= 0
  expect(find(".fc-widget-content.holiday .fc-day-content .total_quantity", match: :first).text).not_to eq ""
end

Angenommen /^ich öffne den Kalender$/ do
  @line_el = if @contract.status == :submitted
               find(".order-line", match: :first)
             elsif @contract.status == :approved
               find(".line[data-line-type='item_line']", match: :first)
             end
  id = @line_el["data-id"] || JSON.parse(@line_el["data-ids"]).first
  @line = ContractLine.find_by_id id
  @line_el.find(".multibutton .button[data-edit-lines]", :text => _("Change entry")).click
  find(".fc-day-content", match: :first)
end

Dann /^kann ich die Anzahl unbegrenzt erhöhen \/ überbuchen$/ do
  @size = @line.model.items.where(:inventory_pool_id => @current_inventory_pool).size*2
  find(".modal #booking-calendar-quantity").set @size
  expect(find(".modal #booking-calendar-quantity").value.to_i).to eq @size
end

Dann /^die Bestellung kann gespeichert werden$/ do
  step 'I save the booking calendar'
  @line.contract.lines.where(:start_date => @line.start_date, :end_date => @line.end_date, :model_id => @line.model).size == @size
end

Dann /^die Aushändigung kann gespeichert werden$/ do
  step 'I save the booking calendar'
  expect(@line.contract.lines.where(:model_id => @line.model).size).to be >= @size
end

Angenommen /^ich editiere alle Linien$/ do
  find(".multibutton .green.dropdown-toggle").click
  find(".multibutton .dropdown-item[data-edit-lines='selected-lines']", :text => _("Edit Selection")).click
end

Dann /^wird in der Liste unter dem Kalender die entsprechende Linie als nicht verfügbar \(rot\) ausgezeichnet$/ do
  find(".modal .line-info.red ~ .col5of10", match: :prefer_exact, :text => @model.name)
end
