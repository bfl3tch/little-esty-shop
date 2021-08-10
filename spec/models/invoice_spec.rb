require 'rails_helper'

RSpec.describe Invoice do
  describe 'associations' do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
    it {should have_many(:discounts).through(:merchants)}
  end

  describe 'validations' do
    it { should validate_presence_of :status }
    it { should define_enum_for(:status).with_values([:cancelled, 'in progress', :completed]) }

  end

  describe 'instance methods' do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Korbanth')
      @merchant2 = Merchant.create!(name: 'asdf')

      @item1 = @merchant1.items.create!(
        name: 'SK2',
        description: "Starkiller's lightsaber from TFU2 promo trailer",
        unit_price: 25_000)
      @item2 = @merchant1.items.create!(
        name: 'Shtok eco',
        description: "Hilt side lit pcb",
        unit_price: 1_500)
      @item3 = @merchant1.items.create!(
        name: 'Hat',
        description: "Signed by MJ",
        unit_price: 60_000)
      @item4 = @merchant2.items.create!(
        name: 'what',
        description: "testy",
        unit_price: 10_000)

      @customer1 = Customer.create!(
        first_name: 'Ben',
        last_name: 'Franklin')

      @invoice1 = @customer1.invoices.create!(status: 0)
      @invoice2 = @customer1.invoices.create!(status: 1)

      @invoice_item1 = InvoiceItem.create!(
        item: @item1,
        invoice: @invoice1,
        quantity: 3,
        unit_price: 1_500,
        status: 1)
      @invoice_item2 = InvoiceItem.create!(
        item: @item2,
        invoice: @invoice1,
        quantity: 2,
        unit_price: 25_000,
        status: 1)
      @invoice_item3 = InvoiceItem.create!(
        item: @item3,
        invoice: @invoice2,
        quantity: 1,
        unit_price: 60_000,
        status: 1)
      @invoice_item4 = InvoiceItem.create!(
        item: @item4,
        invoice: @invoice2,
        quantity: 1,
        unit_price: 60_000,
        status: 1)

      @discount1 = @merchant1.discounts.create(name: 'Twoten', threshold: 2, percentage: 10)
      @discount2 = @merchant1.discounts.create(name: 'Fourscore', threshold: 3, percentage: 20)
      @discount3 = @merchant1.discounts.create(name: 'Ninetwentynine', threshold: 9, percentage: 29)
      @discount4 = @merchant1.discounts.create(name: 'Twentyfifty', threshold: 20, percentage: 50)

      @discount6 = @merchant2.discounts.create(name: 'Two', threshold: 2, percentage: 2)
    end

    describe '#invoice_revenue' do
      it 'calculates the total revenue potential of the invoice' do
        expect(@invoice1.invoice_revenue).to eq(54_500)
      end
    end

    describe '#invoice_item_totals' do
      it 'returns invoice_items that match the invoice' do
        expect(@invoice1.invoice_item_totals).to eq([@invoice_item1, @invoice_item2])
      end
    end

    describe '#find_best_applicable_discounts' do
      it 'finds all discounts that the invoice item is eligible for' do
        expected = {
          @invoice_item1.id => @discount2.percentage,
          @invoice_item2.id => @discount1.percentage
        }
        expect(@invoice1.find_best_applicable_discounts).to eq(expected)
      end
    end

    # describe '#total_discount`' do
    #   it 'calculates the discounted amount' do
    #     require "pry"; binding.pry
    #     expect(@invoice1.total_discount).to eq(4)
    #   end
    # end

    # describe '#apply_discounts' do
    #   it 'applies the discounted amount to the invoice' do
    #     expect(@invoice1.amount_off).to eq(50)
    #   end
    # end



  end

end
