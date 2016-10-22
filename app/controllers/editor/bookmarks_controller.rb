class Editor::BookmarksController < EditorController
  before_action :find_document

  def create
    bookmark = Bookmark.new(document: @document, user: current_user)
    bookmark.save
    redirect_back fallback_location: editor_document_path(@document),
                  flash: { success: "Bookmark for #{@document} added" }
  end

  def destroy
    bookmark = Bookmark.find_by(document: @document, user: current_user)
    bookmark.delete
    redirect_back fallback_location: editor_document_path(@document),
                  alert: "Bookmark for #{@document} removed"
  end
end