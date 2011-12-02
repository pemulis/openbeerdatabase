class ApiPresenter
  def to_json(options = {})
    Yajl::Encoder.encode(as_json)
  end
end
