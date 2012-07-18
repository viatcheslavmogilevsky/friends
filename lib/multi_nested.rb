module MultiNested
  AVAILABLE_OWNERS = ["Comment","Post","Photo"]
  def get_parent(parent_type,parent_id)
    case parent_type
    when "Post"
      Post.find(parent_id)
    when "Photo"
      Photo.find(parent_id)   
    else  
      Comment.find(parent_id)  
    end
  end

  def parent_type_exists?(type, without = nil)
  	arr = AVAILABLE_OWNERS
  	arr.delete(without)
    arr.include?(type)
  end
end