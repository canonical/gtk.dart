enum GType {
  CHAR(3),
  UCHAR(4),
  BOOLEAN(5),
  INT(6),
  UINT(7),
  LONG(8),
  ULONG(9),
  INT64(10),
  UINT64(11),
  FLOAT(14),
  DOUBLE(15),
  STRING(16);

  final int value;
  const GType(this.value);
}
