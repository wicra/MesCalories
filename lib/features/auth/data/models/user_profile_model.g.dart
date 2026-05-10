// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileModelCollection on Isar {
  IsarCollection<UserProfileModel> get userProfileModels => this.collection();
}

const UserProfileModelSchema = CollectionSchema(
  name: r'UserProfileModel',
  id: -8790468936041821297,
  properties: {
    r'activityLevel': PropertySchema(
      id: 0,
      name: r'activityLevel',
      type: IsarType.byte,
      enumMap: _UserProfileModelactivityLevelEnumValueMap,
    ),
    r'age': PropertySchema(
      id: 1,
      name: r'age',
      type: IsarType.long,
    ),
    r'biologicalSex': PropertySchema(
      id: 2,
      name: r'biologicalSex',
      type: IsarType.byte,
      enumMap: _UserProfileModelbiologicalSexEnumValueMap,
    ),
    r'bmr': PropertySchema(
      id: 3,
      name: r'bmr',
      type: IsarType.double,
    ),
    r'carbGoalG': PropertySchema(
      id: 4,
      name: r'carbGoalG',
      type: IsarType.long,
    ),
    r'computedCalorieGoal': PropertySchema(
      id: 5,
      name: r'computedCalorieGoal',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 6,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dailyCalorieGoal': PropertySchema(
      id: 7,
      name: r'dailyCalorieGoal',
      type: IsarType.long,
    ),
    r'fatGoalG': PropertySchema(
      id: 8,
      name: r'fatGoalG',
      type: IsarType.long,
    ),
    r'firstName': PropertySchema(
      id: 9,
      name: r'firstName',
      type: IsarType.string,
    ),
    r'goalType': PropertySchema(
      id: 10,
      name: r'goalType',
      type: IsarType.byte,
      enumMap: _UserProfileModelgoalTypeEnumValueMap,
    ),
    r'heightCm': PropertySchema(
      id: 11,
      name: r'heightCm',
      type: IsarType.double,
    ),
    r'proteinGoalG': PropertySchema(
      id: 12,
      name: r'proteinGoalG',
      type: IsarType.long,
    ),
    r'tdee': PropertySchema(
      id: 13,
      name: r'tdee',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weightKg': PropertySchema(
      id: 15,
      name: r'weightKg',
      type: IsarType.double,
    )
  },
  estimateSize: _userProfileModelEstimateSize,
  serialize: _userProfileModelSerialize,
  deserialize: _userProfileModelDeserialize,
  deserializeProp: _userProfileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userProfileModelGetId,
  getLinks: _userProfileModelGetLinks,
  attach: _userProfileModelAttach,
  version: '3.1.0+1',
);

int _userProfileModelEstimateSize(
  UserProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.firstName.length * 3;
  return bytesCount;
}

void _userProfileModelSerialize(
  UserProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.activityLevel.index);
  writer.writeLong(offsets[1], object.age);
  writer.writeByte(offsets[2], object.biologicalSex.index);
  writer.writeDouble(offsets[3], object.bmr);
  writer.writeLong(offsets[4], object.carbGoalG);
  writer.writeLong(offsets[5], object.computedCalorieGoal);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeLong(offsets[7], object.dailyCalorieGoal);
  writer.writeLong(offsets[8], object.fatGoalG);
  writer.writeString(offsets[9], object.firstName);
  writer.writeByte(offsets[10], object.goalType.index);
  writer.writeDouble(offsets[11], object.heightCm);
  writer.writeLong(offsets[12], object.proteinGoalG);
  writer.writeDouble(offsets[13], object.tdee);
  writer.writeDateTime(offsets[14], object.updatedAt);
  writer.writeDouble(offsets[15], object.weightKg);
}

UserProfileModel _userProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfileModel();
  object.activityLevel = _UserProfileModelactivityLevelValueEnumMap[
          reader.readByteOrNull(offsets[0])] ??
      ActivityLevel.sedentary;
  object.age = reader.readLong(offsets[1]);
  object.biologicalSex = _UserProfileModelbiologicalSexValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      BiologicalSex.male;
  object.carbGoalG = reader.readLong(offsets[4]);
  object.createdAt = reader.readDateTime(offsets[6]);
  object.dailyCalorieGoal = reader.readLong(offsets[7]);
  object.fatGoalG = reader.readLong(offsets[8]);
  object.firstName = reader.readString(offsets[9]);
  object.goalType = _UserProfileModelgoalTypeValueEnumMap[
          reader.readByteOrNull(offsets[10])] ??
      GoalType.lose;
  object.heightCm = reader.readDouble(offsets[11]);
  object.id = id;
  object.proteinGoalG = reader.readLong(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[14]);
  object.weightKg = reader.readDouble(offsets[15]);
  return object;
}

P _userProfileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_UserProfileModelactivityLevelValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ActivityLevel.sedentary) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (_UserProfileModelbiologicalSexValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BiologicalSex.male) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (_UserProfileModelgoalTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          GoalType.lose) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _UserProfileModelactivityLevelEnumValueMap = {
  'sedentary': 0,
  'light': 1,
  'moderate': 2,
  'active': 3,
  'veryActive': 4,
};
const _UserProfileModelactivityLevelValueEnumMap = {
  0: ActivityLevel.sedentary,
  1: ActivityLevel.light,
  2: ActivityLevel.moderate,
  3: ActivityLevel.active,
  4: ActivityLevel.veryActive,
};
const _UserProfileModelbiologicalSexEnumValueMap = {
  'male': 0,
  'female': 1,
};
const _UserProfileModelbiologicalSexValueEnumMap = {
  0: BiologicalSex.male,
  1: BiologicalSex.female,
};
const _UserProfileModelgoalTypeEnumValueMap = {
  'lose': 0,
  'maintain': 1,
  'gain': 2,
};
const _UserProfileModelgoalTypeValueEnumMap = {
  0: GoalType.lose,
  1: GoalType.maintain,
  2: GoalType.gain,
};

Id _userProfileModelGetId(UserProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileModelGetLinks(UserProfileModel object) {
  return [];
}

void _userProfileModelAttach(
    IsarCollection<dynamic> col, Id id, UserProfileModel object) {
  object.id = id;
}

extension UserProfileModelQueryWhereSort
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhere> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProfileModelQueryWhere
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhereClause> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idBetween(
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
}

extension UserProfileModelQueryFilter
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      activityLevelEqualTo(ActivityLevel value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      activityLevelGreaterThan(
    ActivityLevel value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      activityLevelLessThan(
    ActivityLevel value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      activityLevelBetween(
    ActivityLevel lower,
    ActivityLevel upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      ageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      ageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      ageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      ageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'age',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      biologicalSexEqualTo(BiologicalSex value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biologicalSex',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      biologicalSexGreaterThan(
    BiologicalSex value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'biologicalSex',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      biologicalSexLessThan(
    BiologicalSex value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'biologicalSex',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      biologicalSexBetween(
    BiologicalSex lower,
    BiologicalSex upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'biologicalSex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      bmrEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bmr',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      bmrGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bmr',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      bmrLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bmr',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      bmrBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bmr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      carbGoalGEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      carbGoalGGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      carbGoalGLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      carbGoalGBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbGoalG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      computedCalorieGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'computedCalorieGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      computedCalorieGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'computedCalorieGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      computedCalorieGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'computedCalorieGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      computedCalorieGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'computedCalorieGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyCalorieGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyCalorieGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyCalorieGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyCalorieGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyCalorieGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyCalorieGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyCalorieGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyCalorieGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fatGoalGEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fatGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fatGoalGGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fatGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fatGoalGLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fatGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fatGoalGBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fatGoalG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firstName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      firstNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firstName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      goalTypeEqualTo(GoalType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalType',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      goalTypeGreaterThan(
    GoalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalType',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      goalTypeLessThan(
    GoalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalType',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      goalTypeBetween(
    GoalType lower,
    GoalType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      heightCmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heightCm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      heightCmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heightCm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      heightCmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heightCm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      heightCmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heightCm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      proteinGoalGEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      proteinGoalGGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteinGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      proteinGoalGLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteinGoalG',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      proteinGoalGBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteinGoalG',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      tdeeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tdee',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      tdeeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tdee',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      tdeeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tdee',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      tdeeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tdee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      weightKgEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      weightKgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      weightKgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      weightKgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weightKg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension UserProfileModelQueryObject
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQueryLinks
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQuerySortBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByActivityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByActivityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> sortByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByBiologicalSex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biologicalSex', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByBiologicalSexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biologicalSex', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> sortByBmr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmr', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByBmrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmr', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCarbGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbGoalG', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCarbGoalGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbGoalG', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByComputedCalorieGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'computedCalorieGoal', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByComputedCalorieGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'computedCalorieGoal', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByDailyCalorieGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieGoal', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByDailyCalorieGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieGoal', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByFatGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatGoalG', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByFatGoalGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatGoalG', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByFirstName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByFirstNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByGoalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByGoalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByHeightCm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByHeightCmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByProteinGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinGoalG', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByProteinGoalGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinGoalG', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> sortByTdee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tdee', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByTdeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tdee', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension UserProfileModelQuerySortThenBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortThenBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByActivityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByActivityLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityLevel', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByBiologicalSex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biologicalSex', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByBiologicalSexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biologicalSex', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenByBmr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmr', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByBmrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bmr', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCarbGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbGoalG', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCarbGoalGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbGoalG', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByComputedCalorieGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'computedCalorieGoal', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByComputedCalorieGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'computedCalorieGoal', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByDailyCalorieGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieGoal', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByDailyCalorieGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyCalorieGoal', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByFatGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatGoalG', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByFatGoalGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatGoalG', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByFirstName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByFirstNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByGoalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByGoalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByHeightCm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByHeightCmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightCm', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByProteinGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinGoalG', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByProteinGoalGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinGoalG', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenByTdee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tdee', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByTdeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tdee', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension UserProfileModelQueryWhereDistinct
    on QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> {
  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByActivityLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityLevel');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'age');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByBiologicalSex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biologicalSex');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByBmr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bmr');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByCarbGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbGoalG');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByComputedCalorieGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'computedCalorieGoal');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByDailyCalorieGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyCalorieGoal');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByFatGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatGoalG');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByFirstName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByGoalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalType');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByHeightCm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heightCm');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByProteinGoalG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinGoalG');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByTdee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tdee');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weightKg');
    });
  }
}

extension UserProfileModelQueryProperty
    on QueryBuilder<UserProfileModel, UserProfileModel, QQueryProperty> {
  QueryBuilder<UserProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfileModel, ActivityLevel, QQueryOperations>
      activityLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityLevel');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations> ageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'age');
    });
  }

  QueryBuilder<UserProfileModel, BiologicalSex, QQueryOperations>
      biologicalSexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biologicalSex');
    });
  }

  QueryBuilder<UserProfileModel, double, QQueryOperations> bmrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bmr');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations> carbGoalGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbGoalG');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      computedCalorieGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'computedCalorieGoal');
    });
  }

  QueryBuilder<UserProfileModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      dailyCalorieGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyCalorieGoal');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations> fatGoalGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatGoalG');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> firstNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstName');
    });
  }

  QueryBuilder<UserProfileModel, GoalType, QQueryOperations>
      goalTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalType');
    });
  }

  QueryBuilder<UserProfileModel, double, QQueryOperations> heightCmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heightCm');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations> proteinGoalGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinGoalG');
    });
  }

  QueryBuilder<UserProfileModel, double, QQueryOperations> tdeeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tdee');
    });
  }

  QueryBuilder<UserProfileModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<UserProfileModel, double, QQueryOperations> weightKgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightKg');
    });
  }
}
