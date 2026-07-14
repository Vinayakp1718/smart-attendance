// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../features/leave/leave_controller.dart';
import '../../features/dashboard/dashboard_controller.dart';

class ChatMessage {
  final String sender; // 'user' or 'bot'
  final String text;
  final Widget? customCard;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    this.customCard,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AIChatbotWidget extends ConsumerStatefulWidget {
  const AIChatbotWidget({super.key});

  @override
  ConsumerState<AIChatbotWidget> createState() => _AIChatbotWidgetState();
}

class _AIChatbotWidgetState extends ConsumerState<AIChatbotWidget> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  bool _isTyping = false;
  bool _isListening = false;
  final TextEditingController _inputController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Initial greeting message
    _messages.add(
      ChatMessage(
        sender: 'bot',
        text: 'Hello! I am your ISG AI Assistant. 🤖\n\nYou can ask me to:\n'
            '• "Apply casual leave for tomorrow due to family function"\n'
            '• "Show my attendance report for last week"\n'
            '• "Who is absent in my team today?"',
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String rawText) {
    final text = rawText.trim();
    if (text.isEmpty) return;

    _inputController.clear();
    setState(() {
      _messages.add(ChatMessage(sender: 'user', text: text));
      _isTyping = true;
    });
    _scrollToBottom();

    // Process intent
    Future.delayed(const Duration(milliseconds: 1200), () async {
      final reply = await _processIntent(text);
      if (mounted) {
        setState(() {
          _messages.add(reply);
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  Future<ChatMessage> _processIntent(String text) async {
    final clean = text.toLowerCase().trim();

    // 1. General Greeting
    if (clean == 'hi' || clean == 'hello' || clean == 'hey' || clean.contains('help')) {
      return ChatMessage(
        sender: 'bot',
        text: 'Hi there! How can I help you today? You can try commands like "apply sick leave tomorrow" or "who is absent today?".',
      );
    }

    // 2. Navigation / Reports Intent
    if (clean.contains('report') || clean.contains('navigate to') || clean.contains('go to')) {
      if (clean.contains('payroll')) {
        context.go('/payroll');
        return ChatMessage(
          sender: 'bot',
          text: 'Switched page to Payroll Summary. Let me know if you need help with anything else!',
        );
      } else if (clean.contains('attendance') || clean.contains('report')) {
        context.go('/reports');
        return ChatMessage(
          sender: 'bot',
          text: 'Navigated to Reports. You can filter logs by date range, department, and status here.',
        );
      } else if (clean.contains('leave')) {
        context.go('/leave');
        return ChatMessage(
          sender: 'bot',
          text: 'Navigated to Leave Management.',
        );
      } else if (clean.contains('employee')) {
        context.go('/employees');
        return ChatMessage(
          sender: 'bot',
          text: 'Navigated to Employee Directory.',
        );
      }
    }

    // 3. Teammate Attendance Status Intent
    if (clean.contains('absent') || clean.contains('present') || clean.contains('teammate')) {
      final dashboardState = ref.read(dashboardControllerProvider);
      final dashboardVal = dashboardState.value;

      if (dashboardVal == null) {
        return ChatMessage(
          sender: 'bot',
          text: 'I cannot retrieve teammate status at the moment because dashboard metrics are loading. Please try again in a few seconds.',
        );
      }

      if (clean.contains('absent')) {
        final absentList = dashboardVal['absentList'] as List<dynamic>? ?? [];
        if (absentList.isEmpty) {
          return ChatMessage(
            sender: 'bot',
            text: 'All teammates are present today! 🎉 No one is marked absent.',
          );
        } else {
          final names = absentList.map((e) => '${e['firstName'] ?? ''} ${e['lastName'] ?? ''}').join(', ');
          return ChatMessage(
            sender: 'bot',
            text: 'Absent today (${absentList.length} members):\n$names',
          );
        }
      } else {
        final presentList = dashboardVal['presentList'] as List<dynamic>? ?? [];
        if (presentList.isEmpty) {
          return ChatMessage(
            sender: 'bot',
            text: 'No check-ins recorded for teammates today yet.',
          );
        } else {
          final names = presentList.map((e) => '${e['firstName'] ?? ''} ${e['lastName'] ?? ''}').join(', ');
          return ChatMessage(
            sender: 'bot',
            text: 'Present today (${presentList.length} members):\n$names',
          );
        }
      }
    }

    // 4. Apply Leave Intent
    if (clean.contains('leave') || clean.contains('apply')) {
      String leaveType = 'Casual Leave';
      if (clean.contains('sick')) {
        leaveType = 'Sick Leave';
      } else if (clean.contains('paid')) {
        leaveType = 'Paid Leave';
      } else if (clean.contains('half')) {
        leaveType = 'Half Day Leave';
      }

      // Determine Date
      DateTime fromDate = DateTime.now().add(const Duration(days: 1)); // default tomorrow
      DateTime toDate = fromDate;
      String dateLabel = 'tomorrow';

      if (clean.contains('today')) {
        fromDate = DateTime.now();
        toDate = fromDate;
        dateLabel = 'today';
      }

      // Determine Reason
      String reason = 'Applied via ISG AI Assistant';
      final reasonKeywords = ['due to', 'because of', 'for'];
      for (final kw in reasonKeywords) {
        if (clean.contains(kw)) {
          final index = clean.indexOf(kw);
          final rawReason = text.substring(index + kw.length).trim();
          if (rawReason.isNotEmpty) {
            reason = rawReason;
            break;
          }
        }
      }

      final formatter = DateFormat('yyyy-MM-dd');
      final fromStr = formatter.format(fromDate);
      final toStr = formatter.format(toDate);

      try {
        final success = await ref.read(leaveControllerProvider.notifier).applyLeave(
          leaveType: leaveType,
          fromDate: fromStr,
          toDate: toStr,
          reason: reason,
        );

        if (success) {
          return ChatMessage(
            sender: 'bot',
            text: 'Leave application submitted successfully! 🎉',
            customCard: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.accentColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppConstants.accentColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        leaveType,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.accentColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Duration: $fromStr to $toStr ($dateLabel)', style: const TextStyle(fontSize: 12)),
                  Text('Reason: "$reason"', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'STATUS: PENDING REVIEW',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppConstants.warningColor),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return ChatMessage(
            sender: 'bot',
            text: 'Could not apply leave request. Check your balance or try again.',
          );
        }
      } catch (e) {
        return ChatMessage(
          sender: 'bot',
          text: 'Error processing leave request: $e',
        );
      }
    }

    // Default reply
    return ChatMessage(
      sender: 'bot',
      text: "I'm sorry, I didn't quite catch that. You can type commands like:\n"
          '• "apply sick leave tomorrow because of flu"\n'
          '• "show report"\n'
          '• "who is absent today?"',
    );
  }

  void _simulateDictation() {
    if (_isListening) return;
    setState(() {
      _isListening = true;
    });

    try {
      // Define the callback function that JS will invoke
      js.context['onSpeechResult'] = (dynamic text) {
        if (mounted) {
          setState(() {
            _inputController.text = text.toString();
            _isListening = false;
          });
        }
      };

      js.context['onSpeechError'] = (dynamic err) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Speech error: ${err.toString()}')),
          );
        }
      };

      js.context['onSpeechEnd'] = () {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      };

      // Call the JS function to start recognition
      js.context.callMethod('eval', [
        """
        (function() {
          var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
          if (!SpeechRecognition) {
            window.onSpeechError('Speech recognition is not supported in this browser. Please use Chrome.');
            return;
          }
          var recognition = new SpeechRecognition();
          recognition.continuous = false;
          recognition.interimResults = false;
          recognition.lang = 'en-US';

          recognition.onresult = function(event) {
            var result = event.results[0][0].transcript;
            window.onSpeechResult(result);
          };

          recognition.onerror = function(event) {
            window.onSpeechError(event.error);
          };

          recognition.onend = function() {
            window.onSpeechEnd();
          };

          recognition.start();
        })();
        """
      ]);
    } catch (e) {
      // Fallback to simulation if JS evaluation is unavailable
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isListening = false;
            _inputController.text = 'Apply sick leave for tomorrow because of toothache';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 24,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isOpen) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 360,
                  height: 480,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withValues(alpha: 0.75) : Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppConstants.primaryColor.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.psychology, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ISG Assistant',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  Text(
                                    _isTyping ? 'AI is typing...' : 'AI Copilot Active',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 20),
                              onPressed: () => setState(() => _isOpen = false),
                            ),
                          ],
                        ),
                      ),
                      // Chat list
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, idx) {
                            final msg = _messages[idx];
                            final isUser = msg.sender == 'user';

                            return Align(
                              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                constraints: const BoxConstraints(maxWidth: 280),
                                child: Column(
                                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isUser
                                            ? AppConstants.primaryColor
                                            : (isDark ? Colors.grey[900] : Colors.grey[100]),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                                          bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.03),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: Text(
                                        msg.text,
                                        style: TextStyle(
                                          color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    if (msg.customCard != null) msg.customCard!,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (_isTyping) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const SizedBox(
                                width: 30,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      // Input Bar
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey[50],
                          border: Border(
                            top: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isListening ? Icons.graphic_eq : Icons.mic,
                                color: _isListening ? AppConstants.dangerColor : AppConstants.primaryColor,
                              ),
                              onPressed: _simulateDictation,
                              tooltip: 'Simulate Voice Typing',
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[900] : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                                ),
                                child: TextField(
                                  controller: _inputController,
                                  decoration: InputDecoration(
                                    hintText: _isListening ? 'Listening...' : 'Type a command...',
                                    border: InputBorder.none,
                                    hintStyle: const TextStyle(fontSize: 13),
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                  onSubmitted: _handleSend,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: AppConstants.primaryColor,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(Icons.send, color: Colors.white, size: 16),
                                onPressed: () => _handleSend(_inputController.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Floating Button Trigger
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withValues(
                        alpha: 0.2 + (0.3 * _pulseController.value),
                      ),
                      blurRadius: 10 + (10 * _pulseController.value),
                      spreadRadius: 2 * _pulseController.value,
                    )
                  ],
                ),
                child: child,
              );
            },
            child: FloatingActionButton(
              onPressed: () {
                setState(() => _isOpen = !_isOpen);
                if (_isOpen) _scrollToBottom();
              },
              backgroundColor: Colors.transparent,
              elevation: 4,
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
                  ),
                ),
                child: Icon(
                  _isOpen ? Icons.keyboard_arrow_down : Icons.psychology,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
