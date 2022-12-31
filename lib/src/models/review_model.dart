class Review {
  final double score; // from 1 to 5
  final String comment;
  final DateTime date;

  const Review({
    required this.score,
    required this.comment,
    required this.date,
  });
}
