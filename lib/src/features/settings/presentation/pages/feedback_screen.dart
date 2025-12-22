import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedCategory = 'General Feedback';

  final List<String> _categories = [
    'General Feedback',
    'Bug Report',
    'Feature Request',
    'Performance Issue',
    'UI/UX Suggestion',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Real-time character count update
    _feedbackController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    final theme = Theme.of(context);
    final color = isError ? theme.colorScheme.error : Colors.greenAccent;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 16,
          color: theme.colorScheme.surface,
          opacity: 0.9,
          child: Row(
            children: [
              Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendFeedback() async {
    final feedbackText = _feedbackController.text.trim();

    if (feedbackText.isEmpty) {
      _showSnackBar("Please enter your feedback", isError: true);
      return;
    }

    HapticFeedback.lightImpact();

    final String recipientEmail = 'technopradyumn.developer@gmail.com';
    final String subject = 'CopyClip Feedback: $_selectedCategory';

    final String body = 'Category: $_selectedCategory\n'
        '${_emailController.text.trim().isNotEmpty ? "User Contact: ${_emailController.text.trim()}\n" : ""}'
        '$feedbackText\n\n'
        'Sent via CopyClip App';

    // Construct Uri properly
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      // mode: LaunchMode.externalApplication is essential for mailto on many devices
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        _showSnackBar("Opening email app...");
      } else {
        _showSnackBar("No email app found to handle this request", isError: true);
      }
    } catch (e) {
      _showSnackBar("Error: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on background tap
      child: GlassScaffold(
        title: "Send Feedback",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),

              // Header Card
              GlassContainer(
                color: primaryColor.withOpacity(0.1),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.feedback_outlined, size: 48, color: primaryColor),
                    const SizedBox(height: 12),
                    Text(
                      "We'd Love to Hear From You!",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your feedback helps us improve CopyClip and provide you with a better experience.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: onSurfaceColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category Section
              _buildLabel("Category", primaryColor),
              const SizedBox(height: 12),
              GlassContainer(
                color: primaryColor.withOpacity(0.05),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                    style: textTheme.bodyLarge?.copyWith(color: onSurfaceColor),
                    dropdownColor: theme.colorScheme.surface,
                    onChanged: (String? newValue) {
                      if (newValue != null) setState(() => _selectedCategory = newValue);
                    },
                    items: _categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(_getCategoryIcon(value), size: 20, color: primaryColor.withOpacity(0.7)),
                            const SizedBox(width: 12),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Email Section
              _buildLabel("Your Email (Optional)", primaryColor),
              const SizedBox(height: 12),
              GlassContainer(
                color: primaryColor.withOpacity(0.05),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: "your.email@example.com",
                    hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.4)),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor.withOpacity(0.7)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Feedback Text Section
              _buildLabel("Your Feedback", primaryColor),
              const SizedBox(height: 12),
              GlassContainer(
                color: primaryColor.withOpacity(0.05),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _feedbackController,
                  maxLines: 8,
                  maxLength: 1000,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    counterText: "", // Hidden because we use custom counter
                    hintText: "Tell us what you think...",
                    hintStyle: TextStyle(color: onSurfaceColor.withOpacity(0.4)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${_feedbackController.text.length}/1000 characters",
                  style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.5)),
                ),
              ),

              const SizedBox(height: 32),

              // Enhanced Send Button
              _buildSendButton(theme, primaryColor, textTheme),

              const SizedBox(height: 16),

              // Info Help Card
              GlassContainer(
                color: Colors.blue.withOpacity(0.1),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Your feedback will open in your default email app. Please ensure you tap 'Send' in that app to complete the submission.",
                        style: textTheme.bodySmall?.copyWith(color: onSurfaceColor.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
    );
  }

  Widget _buildSendButton(ThemeData theme, Color primaryColor, TextTheme textTheme) {
    return InkWell(
      onTap: _sendFeedback,
      borderRadius: BorderRadius.circular(16),
      child: GlassContainer(
        color: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              "Send Feedback",
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Bug Report': return Icons.bug_report_outlined;
      case 'Feature Request': return Icons.lightbulb_outline;
      case 'Performance Issue': return Icons.speed_outlined;
      case 'UI/UX Suggestion': return Icons.palette_outlined;
      case 'Other': return Icons.more_horiz;
      default: return Icons.feedback_outlined;
    }
  }
}