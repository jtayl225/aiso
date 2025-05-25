import 'package:aiso/models/llm_enum.dart';

class ReportResult {
  final String reportId;
  final String promptId;
  final String prompt;
  final LLM llm;
  final int alpha;
  final int n;
  final double? meanRank;

  ReportResult({
    required this.reportId,
    required this.promptId,
    required this.prompt, 
    required this.llm, 
    required this.alpha, 
    required this.n, 
    this.meanRank, 
    });

  double get pct => n != 0 ? alpha / n : 0;  // returns 0 if n is zero to avoid division by zero
  String get pctString => n != 0 ? '${(alpha / n * 100).toStringAsFixed(1)}%' : '0.0%';

  // fromJson factory constructor
  factory ReportResult.fromJson(Map<String, dynamic> json) {
    return ReportResult(
      reportId: json['report_id'] as String,
      promptId: json['prompt_id'] as String,
      prompt: json['prompt'] as String,
      llm: LLMParsing.fromString(json['llm'] as String),
      alpha: json['alpha'] as int,
      n: json['n'] as int,
      meanRank: json['mean_rank'] != null ? double.tryParse(json['mean_rank'].toString()) : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'promptId': promptId,
      'prompt': prompt,
      'llm': llm.name,  // enum to string
      'alpha': alpha,
      'n': n,
      'mean_rank': meanRank
    };
  }

}