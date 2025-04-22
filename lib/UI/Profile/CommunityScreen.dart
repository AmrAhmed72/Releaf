import 'package:flutter/material.dart';
import 'package:releaf/services/api_service.dart';
import 'package:releaf/models/campaign.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late Future<List<Campaign>> _campaignsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _campaignsFuture = _apiService.getAllCampaigns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color(0xFF609254),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Community",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recent Campaigns",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Campaign>>(
                  future: _campaignsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No campaigns available'));
                    }

                    final campaigns = snapshot.data!;
                    return ListView.builder(
                      itemCount: campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = campaigns[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _campaignCard(campaign),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campaignCard(Campaign campaign) {
    return Container(
      width: 380,
      height: 282,
      decoration: ShapeDecoration(
        color: const Color(0xFFEEF0E2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      color: Color(0xFFC3824D),
                      fontSize: 16,
                      fontFamily: 'Laila',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    campaign.date,
                    style: const TextStyle(
                      color: Color(0xFF4C2B12),
                      fontSize: 14,
                      fontFamily: 'Laila',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    campaign.location,
                    style: const TextStyle(
                      color: Color(0xFF4C2B12),
                      fontSize: 14,
                      fontFamily: 'Laila',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      campaign.description,
                      style: const TextStyle(
                        color: Color(0xFF4C2B12),
                        fontSize: 12,
                        fontFamily: 'Laila',
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement link opening functionality
                      print("Visit website tapped for ${campaign.title}");
                    },
                    child: Text(
                      campaign.link,
                      style: const TextStyle(
                        color: Color(0xFF609254),
                        fontSize: 12,
                        fontFamily: 'Laila',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: Colors.orange,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Icon(
                  Icons.park,
                  color: Colors.green,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Icon(
                      Icons.cloud,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                    Positioned(
                      left: 16,
                      child: Icon(
                        Icons.cloud,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}