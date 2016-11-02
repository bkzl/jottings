require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#bookmarked?" do
    user = create(:user, has_bookmark: true)
    document = user.documents.last

    assert user.bookmarked?(document)
  end

  test "#own_shared_documents?" do
    user_a = create(:user, has_document: true)
    document = user_a.documents.last
    refute user_a.own_shared_documents?

    user_b = create(:user)
    document.collaborators << user_b
    assert user_a.own_shared_documents?

    user_a.documents.last.update(owner: user_b)
    refute user_a.own_shared_documents?
  end

  test "#tree_view" do
    user = create(:user, has_document: true)
    document = user.documents.last
    stack = create(:stack, name: "Zzz", assign_to: user)
    empty_stack = create(:stack, name: "Aaa", assign_to: user)
    in_stack_document_a = create(:document, body: "# Zzz", assign_to: user, stack: stack)
    in_stack_document_b = create(:document, body: "# Aaa", assign_to: user, stack: stack)

    expected = {
      empty_stack => [],
      stack => [in_stack_document_b, in_stack_document_a],
      document => nil
    }

    assert_equal expected, user.tree_view
  end
end
