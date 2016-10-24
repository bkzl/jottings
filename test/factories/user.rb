FactoryGirl.define do
  factory :user do
    transient do
      has_document false
      has_bookmark false
    end

    name Faker::Name.name
    sequence(:email) { |n| Faker::Internet.email(n) }
    password Faker::Internet.password

    after(:create) do |user, evaluator|
      def create_and_assign_document_to(user)
        PaperTrail.whodunnit = user.id
        document = build(:document)
        document.assign_to(user)
        document.save
        document
      end

      if evaluator.has_document
        create_and_assign_document_to(user)
      end

      if evaluator.has_bookmark
        document = create_and_assign_document_to(user)
        create(:bookmark, user: user, document: document)
      end
    end
  end
end
