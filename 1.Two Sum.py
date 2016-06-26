1. Two Sum
Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution.
Example:
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
UPDATE (2016/2/13):
The return format had been changed to zero-based indices. Please read the above updated description carefully.

class Solution(object):
    def twoSum(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: List[int]
        """
        index1=0
        size=len(nums)
        while index1<size:
            index2=index1+1
            while index2 < size:
                if nums[index1]+nums[index2] == target:
        			return index1, index2
                index2 += 1
            index1 +=1

####O(n) solution
class Solution(object):
	def twoSum(self,nums,target):
		dic=dict()
		size=len(nums)
		for x in range(size):
			dic[nums[x]]=x
		for x in range(size):
			index1=x
			index2=dic.get(target-nums[x])
			if index2:
				return index1, index2