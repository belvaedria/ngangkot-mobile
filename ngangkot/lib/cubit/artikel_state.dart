import 'package:equatable/equatable.dart';
import '../models/article.dart';

abstract class ArtikelState extends Equatable {
  const ArtikelState();

  @override
  List<Object> get props => [];
}

class ArtikelInitial extends ArtikelState {}

class ArtikelLoading extends ArtikelState {}

class ArtikelLoaded extends ArtikelState {
  final List<Article> articles;

  const ArtikelLoaded(this.articles);

  @override
  List<Object> get props => [articles];

  ArtikelLoaded copyWith({List<Article>? articles}) {
    return ArtikelLoaded(articles ?? this.articles);
  }
}

class ArtikelError extends ArtikelState {
  final String message;

  const ArtikelError(this.message);

  @override
  List<Object> get props => [message];
}
