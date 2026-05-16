#include <vector>
#include <string>
#include <algorithm>
#include <unordered_map>

class Solution {
public:
	std::vector<std::vector<std::string>> groupAnagrams(std::vector<std::string>& strs)
	{
		std::unordered_map<std::string, std::vector<std::string>> stringMap;

		for (const std::string& str : strs)
		{
			std::string sortedStr = str;
			sort(sortedStr.begin(), sortedStr.end());
			stringMap[sortedStr].push_back(str);
		}

		std::vector<std::vector<std::string>> retval;

		for (auto& pair : stringMap)
		{
			retval.push_back(pair.second);
		}

		return retval;
	}
};
