require 'spec_helper'

describe Review do

  describe 'relations' do
    it { should belong_to(:reviewable) }
    it { should belong_to(:reviewer) }
  end

  describe 'aliases' do
    it 'object should be the same as reviewable' do
      product = build(:product)
      review  = build(:review, reviewable: product)

      review.object.should be(product)
    end

    it 'owner should be the same as reviewer' do
      user = build(:user)
      review  = build(:review, reviewer: user)

      review.owner.should be(user)
    end
  end

  describe '.in_order' do
    subject { Review.in_order }

    it 'first created should be first' do
      review_1 = create(:review, created_at: 6.days.ago)
      review_2 = create(:review, created_at: 2.day.ago)
      review_3 = create(:review, created_at: 1.week.ago)

      expect(subject).to eq([review_3, review_1, review_2])
    end
  end

  describe '.most_recent' do
    subject { Review.most_recent }

    it 'most recent should be first' do
      review_1 = create(:review, created_at: 6.days.ago)
      review_2 = create(:review, created_at: 2.day.ago)
      review_3 = create(:review, created_at: 1.week.ago)

      expect(subject).to eq([review_2, review_1, review_3])
    end
  end

  describe '.lowest_rating' do
    subject { Review.lowest_rating }

    it 'with lowest rating should be first' do
      review_1 = create(:review, rating: 10)
      review_2 = create(:review, rating: 2)
      review_3 = create(:review, rating: 35)

      expect(subject).to eq([review_2, review_1, review_3])
    end
  end

  describe '.highest_rating' do
    subject { Review.highest_rating }

    it 'with lowest rating should be first' do
      review_1 = create(:review, rating: 10)
      review_2 = create(:review, rating: 21)
      review_3 = create(:review, rating: 35)

      expect(subject).to eq([review_3, review_2, review_1])
    end
  end

  describe '.since' do
    it 'should not include reviews with dates less than the given' do
      review_1 = create(:review, created_at: 6.days.ago)
      review_2 = create(:review, created_at: 2.day.ago)
      review_3 = create(:review, created_at: 1.week.ago)

      expect(Review.since(3.days.ago)).to_not include(review_1, review_3)
    end

    it 'should include all reviews created after the given date' do
      review_1 = create(:review, created_at: 6.days.ago)
      review_2 = create(:review, created_at: 2.day.ago)
      review_3 = create(:review, created_at: 1.week.ago)

      expect(Review.since(3.days.ago)).to include(review_2)
    end
  end

  describe '.recent' do
    context 'use since' do
      shared_examples_for 'recent using since' do
        it 'should not include reviews with dates less than the given' do
          review_1 = create(:review, created_at: date + 2.days)
          review_2 = create(:review, created_at: date - 3.days)
          review_3 = create(:review, created_at: date + 1.week)

          expect(Review.recent(date)).to_not include(review_2)
        end

        it 'should include all reviews created after the given date' do
          review_1 = create(:review, created_at: date + 2.days)
          review_2 = create(:review, created_at: date - 3.days)
          review_3 = create(:review, created_at: date + 1.week)

          expect(Review.recent(date)).to include(review_1, review_3)
        end
      end

      context 'for date type' do
        it_should_behave_like 'recent using since' do
          let(:date) { Date.parse('3rd Feb 2001') }
        end
      end

      context 'for time type' do
        it_should_behave_like 'recent using since' do
          let(:date) { Time.now }
        end
      end

      context 'for time with zone type' do
        it_should_behave_like 'recent using since' do
          let(:date) { Time.zone.now }
        end
      end
    end

    context 'use limit' do
      it 'should return only the amount given' do
        create(:review)
        create(:review)
        create(:review)

        expect(Review.recent(2).length).to be(2)
      end
    end
  end

end