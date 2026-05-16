#include <algorithm>
#include <vector>

class Solution {
public:
	bool hasDuplicate(std::vector<int>& nums) {
		sort(nums.begin(), nums.end());
		
		for (int i = 1; i < nums.size(); ++i)
		{
			if (nums[i-1] == nums[i])
			{
				return true;
			}
		}

		return false;
	}
};
