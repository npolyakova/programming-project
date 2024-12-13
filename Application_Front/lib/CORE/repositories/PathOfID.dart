class PathOfID
{
   final List<int> path;

  PathOfID({required this.path});

  factory PathOfID.ToJson(Map<String, dynamic> json)
  {
    return PathOfID(path: json['path'] as List<int>);
  }
}