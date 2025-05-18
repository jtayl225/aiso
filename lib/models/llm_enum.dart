enum LLM {
  chatgpt,
  gemini,
}

extension LLMParsing on LLM {
  static LLM fromString(String value) {
    return LLM.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid LLM value: $value'),
    );
  }
}
