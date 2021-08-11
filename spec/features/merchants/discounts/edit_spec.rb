require 'rails_helper'

RSpec.describe 'The merchants discount edit page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Tom Holland')

    @discount1 = @merchant1.discounts.create(name: 'Threeteen', threshold: 3, percentage: 15)

    allow(API).to receive(:upcoming_holidays).and_return({"Labor Day" => "2021-09-06", "Columbus Day" => "2021-10-11", "Veterans Day" => '2021-11-11'})
    @holidays = API.upcoming_holidays

    visit edit_merchant_discount_path(@merchant1, @discount1)
  end

  it 'displays a form to edit the discount' do
    expect(page).to have_content("Editing #{@discount1.name}")
    expect(find_field('Percentage').value).to eq('15')
  end

  it 'wont let you submit a form without all the necessary data' do

    expect(page).to have_content("#{@discount1.threshold}")
    expect(find_field('Percentage').value).to eq('15')

    fill_in 'Percentage', with: ""
    click_on "Update Discount"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Discount not updated")
    expect(page).to have_content('15')
  end

  it 'wont let you submit a form without all the necessary data' do
    expect(page).to have_content('3')
    fill_in 'Threshold', with: '0'
    click_on "Update Discount"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Discount not updated")
    expect(page).to have_content('3')
  end

  it 'wont let you submit a form without all then necessary data' do
    expect(page).to have_content('Threeteen')

    fill_in 'Name', with: ""
    click_on "Update Discount"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Discount not updated")
    expect(page).to have_content('Threeteen')
  end

  it 'redirects you and gives you a successful message if you edit it properly' do
    expect(page).to have_content('Threeteen')

    fill_in 'Name', with: "Fourteen"
    fill_in 'Threshold', with: '4'
    fill_in 'Percentage', with: "14"

    click_on "Update Discount"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content("Fourteen")
    expect(page).to have_content('4')
    expect(page).to have_content('14')
  end

end
