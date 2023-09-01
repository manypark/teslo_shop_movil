import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

final producFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>( (ref, product) {

  // final createUpdateCallback = ref.watch( productsRepositoryProvider ).createUpdateProduct;
  final createUpdateCallback = ref.watch( prodcutsProvider.notifier ).createOrUpdateProduct;

  return ProductFormNotifier(
    product         : product,
    onSubmitCallback: createUpdateCallback
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {

  final Future<bool> Function( Map<String, dynamic> productLike )? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }):super( 
    ProductFormState(
      id          : product.id,
      title       : Title.dirty(product.title),
      slug        : Slug.dirty(product.slug),
      price       : Price.dirty(product.price),
      inStock     : Stock.dirty(product.stock),
      sizes       : product.sizes,
      gender      : product.gender,
      description : product.description,
      tags        : product.tags.join(', '),
      images      : product.images,
    )
  );

  void onTitleChange( String value ) {

     state = state.copyWith(
      title      : Title.dirty(value),
      isFormvalid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
     );

  }

  void onSlugChange( String value ) {

     state = state.copyWith(
      slug      : Slug.dirty(value),
      isFormvalid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
     );

  }

  void onPriceChange( double value ) {

     state = state.copyWith(
      price      : Price.dirty( value ),
      isFormvalid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty( state.slug.value ),
        Price.dirty(value),
        Stock.dirty(state.inStock.value),
      ])
     );

  }

  void onStockChange( int value ) {

     state = state.copyWith(
      inStock      : Stock.dirty( value ),
      isFormvalid: Formz.validate([
        Title.dirty( state.title.value ),
        Slug.dirty( state.slug.value ),
        Price.dirty( state.price.value ),
        Stock.dirty(value),
      ])
     );

  }

  void onSizeChange( List<String> sizes ) {
    state = state.copyWith( sizes:sizes );
  }

  void onGenderChange( String gender ) {
    state = state.copyWith( gender:gender );
  }

  void onDescripcionChange( String desc ) {
    state = state.copyWith( description:desc );
  }

  void onTagsChange( String tags ) {
    state = state.copyWith( tags:tags );
  }
  
  void _touchedEverthing() {

    state = state.copyWith(
      isFormvalid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
    );

  }

  Future<bool> onFormSubmit() async {

    _touchedEverthing();

    if( !state.isFormvalid ) return false;

    if( onSubmitCallback == null ) return false;

    final productLike = {
      'id'          : ( state.id == 'new' ) ? null : state.id,
      'title'       : state.title.value,
      'price'       : state.price.value,
      'description' : state.description,
      'slug'        : state.slug.value,
      'stock'       : state.inStock.value,
      'sizes'       : state.sizes,
      'gender'      : state.gender,
      'tags'        : state.tags.split(','),
      'images'      : state.images.map( ( img ) => img.replaceAll('${Environment.apiUrl}/files/product/', '') ).toList(),
    };

    try {
      return await onSubmitCallback!( productLike );
    } catch (e) {
      return false;
    }

  }

  void updateProductImage( String path ) {
    state = state.copyWith( images: [ ...state.images, path ] );
  }

}

class ProductFormState {

  final bool isFormvalid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormvalid = false, 
    this.id, 
    this.title = const Title.dirty(''), 
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const  []
  });

  ProductFormState copyWith({
    bool? isFormvalid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    id          :  id           ?? this. id,
    isFormvalid :  isFormvalid  ?? this.isFormvalid,
    title       :  title        ?? this. title,
    slug        :  slug         ?? this. slug,
    price       :  price        ?? this. price,
    sizes       :  sizes        ?? this. sizes,
    gender      :  gender       ?? this. gender,
    inStock     :  inStock      ?? this. inStock,
    description :  description  ?? this. description,
    tags        :  tags         ?? this. tags,
    images      :  images       ?? this. images,
  );
  
}

