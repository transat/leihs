Feature: Item Hover on daily view

  In order to see the lines of a contract
  As a Manager
  I want to see a list of lines on hover

  Background:
    Given I am Pius

  @personas
  Scenario: Hover item cell to see lines
    When I open the daily view
    And I hover an item's cell
    Then I see a list of items
    And items of the same models are merged
    And I see the quantity for each merged line
