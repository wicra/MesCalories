// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_entry_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealEntryModelCollection on Isar {
  IsarCollection<MealEntryModel> get mealEntryModels => this.collection();
}

const MealEntryModelSchema = CollectionSchema(
  name: r'MealEntryModel',
  id: -6740113102480985630,
  properties: {
    r'aiProvider': PropertySchema(
      id: 0,
      name: r'aiProvider',
      type: IsarType.string,
    ),
    r'aiSummary': PropertySchema(
      id: 1,
      name: r'aiSummary',
      type: IsarType.string,
    ),
    r'calories': PropertySchema(
      id: 2,
      name: r'calories',
      type: IsarType.long,
    ),
    r'carbsG': PropertySchema(
      id: 3,
      name: r'carbsG',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 5,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'detectedFoodsJson': PropertySchema(
      id: 6,
      name: r'detectedFoodsJson',
      type: IsarType.string,
    ),
    r'fatsG': PropertySchema(
      id: 7,
      name: r'fatsG',
      type: IsarType.double,
    ),
    r'fibersG': PropertySchema(
      id: 8,
      name: r'fibersG',
      type: IsarType.double,
    ),
    r'inputMode': PropertySchema(
      id: 9,
      name: r'inputMode',
      type: IsarType.string,
    ),
    r'loggedAt': PropertySchema(
      id: 10,
      name: r'loggedAt',
      type: IsarType.dateTime,
    ),
    r'photoPath': PropertySchema(
      id: 11,
      name: r'photoPath',
      type: IsarType.string,
    ),
    r'proteinsG': PropertySchema(
      id: 12,
      name: r'proteinsG',
      type: IsarType.double,
    ),
    r'rawAiResponse': PropertySchema(
      id: 13,
      name: r'rawAiResponse',
      type: IsarType.string,
    ),
    r'userInput': PropertySchema(
      id: 14,
      name: r'userInput',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 15,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _mealEntryModelEstimateSize,
  serialize: _mealEntryModelSerialize,
  deserialize: _mealEntryModelDeserialize,
  deserializeProp: _mealEntryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mealEntryModelGetId,
  getLinks: _mealEntryModelGetLinks,
  attach: _mealEntryModelAttach,
  version: '3.1.0+1',
);

int _mealEntryModelEstimateSize(
  MealEntryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.aiProvider.length * 3;
  bytesCount += 3 + object.aiSummary.length * 3;
  bytesCount += 3 + object.detectedFoodsJson.length * 3;
  bytesCount += 3 + object.inputMode.length * 3;
  {
    final value = object.photoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rawAiResponse.length * 3;
  bytesCount += 3 + object.userInput.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _mealEntryModelSerialize(
  MealEntryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aiProvider);
  writer.writeString(offsets[1], object.aiSummary);
  writer.writeLong(offsets[2], object.calories);
  writer.writeDouble(offsets[3], object.carbsG);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeDateTime(offsets[5], object.date);
  writer.writeString(offsets[6], object.detectedFoodsJson);
  writer.writeDouble(offsets[7], object.fatsG);
  writer.writeDouble(offsets[8], object.fibersG);
  writer.writeString(offsets[9], object.inputMode);
  writer.writeDateTime(offsets[10], object.loggedAt);
  writer.writeString(offsets[11], object.photoPath);
  writer.writeDouble(offsets[12], object.proteinsG);
  writer.writeString(offsets[13], object.rawAiResponse);
  writer.writeString(offsets[14], object.userInput);
  writer.writeString(offsets[15], object.uuid);
}

MealEntryModel _mealEntryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealEntryModel();
  object.aiProvider = reader.readString(offsets[0]);
  object.aiSummary = reader.readString(offsets[1]);
  object.calories = reader.readLong(offsets[2]);
  object.carbsG = reader.readDouble(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.date = reader.readDateTime(offsets[5]);
  object.detectedFoodsJson = reader.readString(offsets[6]);
  object.fatsG = reader.readDouble(offsets[7]);
  object.fibersG = reader.readDouble(offsets[8]);
  object.id = id;
  object.inputMode = reader.readString(offsets[9]);
  object.loggedAt = reader.readDateTime(offsets[10]);
  object.photoPath = reader.readStringOrNull(offsets[11]);
  object.proteinsG = reader.readDouble(offsets[12]);
  object.rawAiResponse = reader.readString(offsets[13]);
  object.userInput = reader.readString(offsets[14]);
  object.uuid = reader.readString(offsets[15]);
  return object;
}

P _mealEntryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mealEntryModelGetId(MealEntryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealEntryModelGetLinks(MealEntryModel object) {
  return [];
}

void _mealEntryModelAttach(
    IsarCollection<dynamic> col, Id id, MealEntryModel object) {
  object.id = id;
}

extension MealEntryModelByIndex on IsarCollection<MealEntryModel> {
  Future<MealEntryModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  MealEntryModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<MealEntryModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<MealEntryModel?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(MealEntryModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(MealEntryModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<MealEntryModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<MealEntryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension MealEntryModelQueryWhereSort
    on QueryBuilder<MealEntryModel, MealEntryModel, QWhere> {
  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension MealEntryModelQueryWhere
    on QueryBuilder<MealEntryModel, MealEntryModel, QWhereClause> {
  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause>
      uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MealEntryModelQueryFilter
    on QueryBuilder<MealEntryModel, MealEntryModel, QFilterCondition> {
  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiProvider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiProvider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiProvider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiProvider',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiProvider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiProvider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiProvider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiProvider',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiProvider',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiProviderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiProvider',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiSummary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiSummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      aiSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      caloriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      caloriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      caloriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      caloriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      carbsGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      carbsGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      carbsGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      carbsGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbsG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detectedFoodsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detectedFoodsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detectedFoodsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detectedFoodsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'detectedFoodsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'detectedFoodsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'detectedFoodsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'detectedFoodsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detectedFoodsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      detectedFoodsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'detectedFoodsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fatsGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fatsGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fatsGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fatsGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatsG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fibersGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fibersG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fibersGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fibersG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fibersGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fibersG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      fibersGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fibersG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inputMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inputMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inputMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inputMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inputMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inputMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inputMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inputMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inputMode',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      inputModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inputMode',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      loggedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loggedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      loggedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'loggedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      loggedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'loggedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      loggedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'loggedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoPath',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoPath',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      photoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      proteinsGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      proteinsGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteinsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      proteinsGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteinsG',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      proteinsGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteinsG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawAiResponse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawAiResponse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawAiResponse',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      rawAiResponseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawAiResponse',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userInput',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userInput',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userInput',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userInput',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userInput',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userInput',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userInput',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userInput',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userInput',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      userInputIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userInput',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension MealEntryModelQueryObject
    on QueryBuilder<MealEntryModel, MealEntryModel, QFilterCondition> {}

extension MealEntryModelQueryLinks
    on QueryBuilder<MealEntryModel, MealEntryModel, QFilterCondition> {}

extension MealEntryModelQuerySortBy
    on QueryBuilder<MealEntryModel, MealEntryModel, QSortBy> {
  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByAiProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiProvider', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByAiProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiProvider', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByAiSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByAiSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByDetectedFoodsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedFoodsJson', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByDetectedFoodsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedFoodsJson', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByFatsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatsG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByFatsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatsG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByFibersG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fibersG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByFibersGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fibersG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByInputMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByInputModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByLoggedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByProteinsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinsG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByProteinsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinsG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByRawAiResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAiResponse', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByRawAiResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAiResponse', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByUserInput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userInput', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      sortByUserInputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userInput', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension MealEntryModelQuerySortThenBy
    on QueryBuilder<MealEntryModel, MealEntryModel, QSortThenBy> {
  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByAiProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiProvider', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByAiProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiProvider', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByAiSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByAiSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiSummary', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByDetectedFoodsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedFoodsJson', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByDetectedFoodsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedFoodsJson', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByFatsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatsG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByFatsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatsG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByFibersG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fibersG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByFibersGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fibersG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByInputMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByInputModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByLoggedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByProteinsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinsG', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByProteinsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinsG', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByRawAiResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAiResponse', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByRawAiResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawAiResponse', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByUserInput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userInput', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy>
      thenByUserInputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userInput', Sort.desc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension MealEntryModelQueryWhereDistinct
    on QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> {
  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByAiProvider(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiProvider', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByAiSummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiSummary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbsG');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct>
      distinctByDetectedFoodsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detectedFoodsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByFatsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatsG');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByFibersG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fibersG');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByInputMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loggedAt');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByPhotoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct>
      distinctByProteinsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinsG');
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct>
      distinctByRawAiResponse({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawAiResponse',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByUserInput(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userInput', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntryModel, MealEntryModel, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension MealEntryModelQueryProperty
    on QueryBuilder<MealEntryModel, MealEntryModel, QQueryProperty> {
  QueryBuilder<MealEntryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealEntryModel, String, QQueryOperations> aiProviderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiProvider');
    });
  }

  QueryBuilder<MealEntryModel, String, QQueryOperations> aiSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiSummary');
    });
  }

  QueryBuilder<MealEntryModel, int, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<MealEntryModel, double, QQueryOperations> carbsGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbsG');
    });
  }

  QueryBuilder<MealEntryModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MealEntryModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MealEntryModel, String, QQueryOperations>
      detectedFoodsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detectedFoodsJson');
    });
  }

  QueryBuilder<MealEntryModel, double, QQueryOperations> fatsGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatsG');
    });
  }

  QueryBuilder<MealEntryModel, double, QQueryOperations> fibersGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fibersG');
    });
  }

  QueryBuilder<MealEntryModel, String, QQueryOperations> inputModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputMode');
    });
  }

  QueryBuilder<MealEntryModel, DateTime, QQueryOperations> loggedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loggedAt');
    });
  }

  QueryBuilder<MealEntryModel, String?, QQueryOperations> photoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoPath');
    });
  }

  QueryBuilder<MealEntryModel, double, QQueryOperations> proteinsGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinsG');
    });
  }

  QueryBuilder<MealEntryModel, String, QQueryOperations>
      rawAiResponseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawAiResponse');
    });
  }

  QueryBuilder<MealEntryModel, String, QQueryOperations> userInputProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userInput');
    });
  }

  QueryBuilder<MealEntryModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
