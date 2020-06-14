String plural(int size, {String singular = '', String plural = 's'}) {
  if (size == 0 || size > 1)
    return plural;
  else
    return singular;
}
